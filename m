Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C969CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82FD6B00B7; Wed,  2 Sep 2026 04:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C336C6B00B8; Wed,  2 Sep 2026 04:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70F26B00B9; Wed,  2 Sep 2026 04:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 994C46B00B7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:18:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FCBCA0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:18:52 +0000 (UTC)
X-FDA: 85168121304.07.9E59555
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 82F5840007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:18:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pscqmjVg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QPGyS0AHVOfUWMfJXbkr/UK6bKLRAGXdQYLecgn4LSo=;
	b=euI5nuwmh5ik+PLKdGf4/Wf1jDhoRmdALkzd6TWhniMyymwDORSu729Z4qj0iZrIVPHgRH
	YM0JYphzU6WPyHSSHv5PFVeO87j7/hGIqBwS/fesQt4tKUuoqWDc0R8EfSiTuQ7Xhli5PL
	z4GoiG8rjJUKHqgbb2w9SSEjwXQTL2Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pscqmjVg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337130;
	b=2JG1HWAxEimMW/HNv1vs9s7LXR901WjwJSKn8mtPdQYJPgvvUZL1r78/hVAS9Y/ORwj6wn
	yyX0TkO97Xhk77nCzFdTufnftiDFN2D7OwevLpCGdFDkr1AZZzOsoP41WKCcRfDRvgEQ9k
	4qJfES8oQ2AQr2+A6r5SDRzMI7de2yE=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-395cf2535acso807442a91.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 01:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788337129; x=1788941929; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QPGyS0AHVOfUWMfJXbkr/UK6bKLRAGXdQYLecgn4LSo=;
        b=pscqmjVgMsozTNs7SvzG3xpZ2qnEPLDwE1w8iwkfw6piId9q6mZPHX0iJ6Ru6hKOG3
         yM/XmMckYVNxVx1iyh21x+l49S4ScTw26YdW4iODr4BQ0+saI1jdt9/17qMuf12oia3S
         u+JtWTF5DyJT+n60/1VPWjLC2Iq8WGIOhaDJCkpFxmoHURL9OpG8ymN/hgVwACTldOJ8
         t4qQ/qqTMjUF8zQY35r0/HVto2QodhkvSK2KYMUP2Y25ue5R8SyQsuE8oIt330IomxGk
         RRTPvekGyNvSieBoudLpNjDG2teEdo0ue7XA7TuIDyLxWJdVieNpcl/xzJUZsyBxwJyi
         qEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788337129; x=1788941929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QPGyS0AHVOfUWMfJXbkr/UK6bKLRAGXdQYLecgn4LSo=;
        b=EOzAA4u8iPWWG04pfRIOBdHZG1jWwz4QS4xlJBASlJ38Lh509bikDnX/TiFS9Bg4f/
         Y3AJJeZ2PNDS15fUgda4EWFJGvG51e/C/XYixosqIKrEDf0PSOzvEXxfoj2b6TqF5f5C
         ASJlCqVOnJCfzx0biOsS0Wre0W/0xOqE5Kdme6XoRn/IdUl3z+TiFcQ5p/N146kZD2fh
         xwBh2lDFFXGV78Ymafs4GPMNhulN9PLiFGlxT/6BhV58KuYzOohn+xstxfMsBictPhZT
         ZncNzkXrkxv98SPS+xRp+dh2voAiqA3PnuYs5seB3B1CrTxTBhPBKPg07X+/zuETiTIm
         HJUg==
X-Forwarded-Encrypted: i=1; AKwUvBy+eEfukXHt156JzTC49gJpw+csa9Sw68vmtRl3r83atz9pAJeuIJdDahkajtj/4hlIayukN9gA+A==@kvack.org
X-Gm-Message-State: AFuF++k+279n74AAAiPxbZ0yaRGj1qio/u6vhdbD3485qoBdveKJjLHV
	+Iw/cW4P31Yrcpz61CHQATjEbzsK/XnwBXY7m9NrSd7iCwqtLThr88/o
X-Gm-Gg: AYBFou3h1TnUGm9BILQcqo9H2+l4F9WffDH8m6q3tSvBnJtd9uZDSDNkTzkmM5egJfg
	sqDp4vpByoLXDa+jWm0aLJgHH9Bfa2ivNVjzRELaDKxC3zJbVObOH+h9o6ppYEnXB2eQKW0T8GY
	9u0ofC6t21h0ueLKM27TxOKEXuppIyMaMzi3NkpTCkyxeOBpVsfjwgMWMSNMJ/zv68xU7D+evKW
	3GGCO6mNbAuGjI3kzcEQDk0drV67qpjsNRgWvgHYhaMMnVdUmr1rzFVdgtxY9jMu+vTHM2pD03/
	Po+RGZoTczT81y2GiY8So+WtYeF06ZjCQcBGAvHzf9VZ3x55O7tFL9VNgIGJwFzE6H7S3lhqZ+G
	qpa9izRqEprq8xVA3awvNRzca0QS1nVwKhOGSRSboTcAU94lte8m2NDYfgYZhWkrrSUk1fk07Ba
	HK7agBIqO8If0bYIXFOIJ1d+gEtayWUEN4w6G2xtXEKXAR73JyF/4G1kusajZInKerQxLccVP0i
	BRq2AbOH6Bojj30
X-Received: by 2002:a17:90b:2f84:b0:398:9bd3:d6d1 with SMTP id 98e67ed59e1d1-39af64e0adbmr1153860a91.11.1788337129220;
        Wed, 02 Sep 2026 01:18:49 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d75b540sm10430157a91.10.2026.09.02.01.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:18:48 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix false positive in
Date: Wed,  2 Sep 2026 16:18:25 +0800
Message-ID: <20260902081825.18931-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9g7o7gkbswjostcdutkz4e4g9yz9ode5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82F5840007
X-Rspam-User: 
X-HE-Tag: 1788337130-599241
X-HE-Meta: U2FsdGVkX1+214am9At0g89yf5Lt8bQsaSK5amHMTfXarMyDkUJx8euaV5VFQKMMm3BwnFG08kioVvJWpw65JpBFI2M6FkGhJ9R3cLf4VXYZ9yS04G8TCl/5ovC0b5sQY8tDlWug8+XOo931AuK2ilvP1PIGNZEbaTOiEvrtbFXbJIHcGFPBMscD80xftnmnNs8fQamaWu9o+PS/NFXv+cgH4q6zcfM890ZDvijbCwAc+JYYiCjpq7wsYdgMmNQTlZsm9oMF/rEkXBHgXOBkTPVVHVNCc/32bK5FMqA/DWmTm/klLUExgV0q4O1X8vll2PNBN3Bo2a/R6FPBRGO0Nn4f9u3m2ItL1+yGUlkaQk1OVv99tUmppmCj7pqMHWE1maRyaPl4juwXFXsRyl/EaW1xW1ooZXw6TNgtRInFJxGMdi4+ohOakbgn5p842gXDSNwRZYgjqSFCu4ExlhY6XHn9VcZBqPJaudsCZsc5ILIogjy/vhW4NYxpeWyeeZ/JimtXJU6FvBRe6Lekwk+8CCi1bBtbIuXk4gR7M8Ks3RnJ+XiMkYCi4zs4wpjhwWPJJ4VNg0F3BxOvQhydNcfx3c5EJ/l8YEsElNdj30vy2hcdsGxM2/R+JNZ2iGwqzNJdNZrpqF6/iCOoNd0iMm83Eh5OSuhuKdcixB3BoC86s6ercWs3dm+TJkk+6lpTWh9/IcK/YSTM+sTj4Xhc9b/AUZ+Vs+jJazGtQqrsicaMN+dDj0QmgslhRnZGOdI2+9FXp81CM90pwib2eCzMcW1/uac1PAxMUUlrCEYc1I5vRZC/LIeMyTzmL2x+UOSTfW6lyPugKk45WBB741fG/f7BxUZbstGV0WpNcPJsdG6EoXuGt5pSTTomO26k6IgAv5lJ3yIXvYr7QLrYktRyNK75OQWJTY02sANIJCoDMhaogTY6qFUdZKhutWe2L7vp5Nm7bryu10YX9GhaHmZbCgD
 eB77/0z1
 B6jW1zRrl5Qpzur5Dg607DI7LH+S587aYE8uA28qtP/lz3TRxRfFeFR/s0jPh6LE+CpY3yvPPxsNnS8tHvJWjMqFff/dDA/uGcAFts6sqsvI0e59vl8r8NhUwJ1EbJ0TAvh8cE0t0nuWp2WmtYVow/R4+wnCbnTOwiZ2KkgVvS3VPmVG0IfY5jJnvpVyxcLQ+stONrNYjtPDvFWdj42q8HRBAOP0SXWKM4TP5YZqr+V6nP9HLfQlD8gW/kCZYqkCSJC3FW9dNp2KRhzKbvJN3XNFa0qIfl75qIZW/bfOqCPgjbu7d6vOAtpsSQHynf4gQcj6GB5gmVrPhjFFwxhFRYMKYGBlZJ6yB2lbhZJoq8CsX8ZBzPuyvh+trhRx/saUne8T1T3kon5F5IQpi1LwvJ9wmbpvhnTybvTtYaHAsx91kLqPFKTJqtPo/kWC//0HzS80p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When setting goal_tuner to 'temporal', if the goal is achieved,
quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
will always return true, even if no regions have been tried to apply at
all.  This causes qt_exceeds to increase unexpectedly.

Fix it by:

- Returning false in damos_quota_is_full() when quota->charged_sz is
  zero.
- Adding an early exit in damon_do_apply_schemes() for schemes with zero
  esz.

Fixes: c7ec7d5f6b3d ("mm/damon/core: handle <min_region_sz remaining quota as empty")
Cc: <stable@vger.kernel.org> # v7.2.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v1:
- v1: https://lore.kernel.org/damon/20260901105925.106186-1-aethernet65535@gmail.com
- Changed the check in damos_quota_is_full() from '!quota->esz' to
  '!quota->charged_sz', because the former is an upper bound, while the
  latter represents the actual quota usage.
- Added an early exit in damon_do_apply_schemes() to prevent a scheme
  with zero esz from being evaluated by damos_quota_is_full().
- Changed patch title, original title: always return false when esz is
  zero

---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8e3ded1a2cf6..de78ad56c8b3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2560,6 +2560,8 @@ static bool damos_quota_is_full(struct damos_quota *quota,
 {
 	if (!damos_quota_is_set(quota))
 		return false;
+	if (!quota->charged_sz)
+		return false;
 	if (quota->charged_sz >= quota->esz)
 		return true;
 	/*
@@ -2666,6 +2668,9 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (!s->wmarks.activated)
 			continue;
 
+		if (!quota->esz)
+			continue;
+
 		/* Check the quota */
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
-- 
2.55.0


