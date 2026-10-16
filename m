Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 230B7CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6CD6B0099; Fri, 16 Oct 2026 00:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372DE6B009B; Fri, 16 Oct 2026 00:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C1E6B009D; Fri, 16 Oct 2026 00:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA7246B0099
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69C66802BE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:44 +0000 (UTC)
X-FDA: 85327248888.02.136A936
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A20B580006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Cd9Vy8je;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
	b=VjkAHGRaongR0lXa6GwB21+S8ZsoNgLJKh/DfUUN4Ig9aaLjwmg2TSpKhXL7nQCC0NKSZK
	ujsTZAvtCixeY5kYIYfWxEKPwqdvUa65fPvTFe/hxeykXgrNk3VRHxp1pkb6TCRSPSWNH6
	z0CLOeF2rUgiej6M8ZVbKz0ScdcRqLc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125882;
	b=6G3smlyfg49mPQ1+eSreddJX0KzMo8g1qg9OyhbMVWV5nx8bufGLKAg5/led5OYb8DzWek
	APns46wlDQqng+Z+nQ1fC52K4L/yeXAEhlBPOaW8MLI5feARApejy7o+aE+dDIdafLZ96f
	XtjFSobIwK+P0OFm0NWQpApMXrEczEc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Cd9Vy8je;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e8246b13cbso44479945ad.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125881; x=1792730681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
        b=Cd9Vy8jeY3rqHqLHCTudBmgHMlO9rc/ZpUBODNjxccuwGT7qRdDhU/vXwXI5nnU/Ss
         W9v0lHhYM1fzIecxHM8Faze6VgCwbN9NLjtzboWgVqdh4j9O21vcrbJjHEGhxDxdFFHv
         0BF8Gn9qfbqNwakh2lYTvOeXWayYeErYcJYhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125881; x=1792730681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kSllIrSwa3+mZd7MmtH8oNKCmldtJhE3Jr9UEV+PDik=;
        b=RVhHL2025ZRcyBcRhzj6Hn7fjqIZ5CKHS1M3aLawLr4OsIxzmaf7Mp47q/2OgG2Ywb
         b7zDyLEcOwyFgaoBtSOwKzKYBChQ7lSLtscGPOpKW5vkwqMyAqWUHaSspl0vC1LOVQXY
         cys7TzBC/o1AzAn1UnpKY08E8+PNIOh38/EmTKzg26WUUsEVutPq/T7ESU8yOhkBhXNn
         Mc3K8MHIm9tWUhQfZx6aTwG+UjtKAI9Am8eF/BV2ZlENc1AemSTiTVLCwdZtE0qfrTWT
         XZ1yi9sFcheuc/BT1BB6rW7+FJhzdO+OXug7AS2JCHknEQYgcsBZuKLdap841XOrTqqA
         MVpw==
X-Forwarded-Encrypted: i=1; AKwUvByrKsJBrLGvBixB3CJtQBcmaEI0Y5BBSFGcyOUGMKTxuWu0YcQ6JZh0W1JWk+pKm2V+0lHqcP9Y2g==@kvack.org
X-Gm-Message-State: AFq9FYLAwYPUL/EreQXy1ir4pJWSFX1naBncI4RRyL4mbZOz8LDlhO/w
	QctOcPQ5blyfPW5I/nfS8oZXOYq6pjG9M+47rCV3RLrdpPCb2NbJNbunV6BoCrYfCw==
X-Gm-Gg: AYBFou1bJ2wo/FcD4FAF5Ehxnh1ojSGm7kt8ZSOxTF4MYvfNpZ/2ku+Tm88eNPKKlb2
	50Bi3XzXyVBNtOI+lixEDhJdAbf9vYsiR72rJNs+0MOjnX52zps6EK+xlQkrRnW1shMatJ9FN9t
	Sa9iXNEY/H+NrJRyofgCep0d8+p5W8zgUWN4Iez9fDFDAJ+WF9TtTZfdf8yzo4QfJZmbZtELeTb
	GDQb1FxHVf30RKdQ68kcy9p+aN34FhBza6lYSUzPm8QmSe23rMk3JUYhpajbmQSqrw6CJGui7P6
	R0wNdg4O1Xo2IbanNSnCbyWwHgPNGiFlFEsNNk01YozhJ8R7NMZ53JQn2gkoveFOLtaJqY3nrgP
	rvAQzf3hOiw+Qu6+WDI+Vxg2nEER5EMaa0NKgNB//Y8N7plmVNh3XBXS8ssO3kogAut3SxDc42q
	1CexunR1owca54aQKjxN05y0iNryP1oIiDP88jw3qMKGdvZ8td/fy8JOByrKZ/zgdH1zqyYDlxE
	gq2WVag9m2kgsb+0TU8M88TeRZHHJjaWylcB4HGODQca/gvWiPbmVOc1j61da0=
X-Received: by 2002:a17:903:240b:b0:2e9:8505:5471 with SMTP id d9443c01a7336-2e985055683mr10946845ad.7.1792125881530;
        Thu, 15 Oct 2026 21:44:41 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:41 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 02/12] zram: remove debugfs entry on init failure
Date: Fri, 16 Oct 2026 13:44:07 +0900
Message-ID: <20261016044429.1304561-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A20B580006
X-Rspam-User: 
X-Stat-Signature: jef55kykn1n17m3nj74ky5skkpqm7s69
X-HE-Tag: 1792125882-745284
X-HE-Meta: U2FsdGVkX19HI9D0WP5Lqi5QIwXVG3y/iJuzcdJLJ7aMTvqwBx8gf+Xnb0iCPV/fpyhl/8r+oYCLVIQaw2u43pa5yyu+NBBpEedaLvWxUyPPbumiu+d8Qp2t3iPEhoEiQ08egqPBzNvCRpKCunA6Hefvpx+vt713bMNXWql+xb79QO7b2x/2rQ0Ed+EdaTDeWX6dOQyacDuM2NuOa6DCDdyIPkqNtgFGrO92O9qqMdrFXqNYKMj96YrCEtP27g6+7W5aKe7mjwANyhA4hRxHCjKDUixX5hFdwJuqZGnPm1gkkEPAAkG/+zRzyRy2bqJy9KpDyUlZSMetgflQ8M2ZuA/aaeFIQKS5hD8Rs8F6ru98KsKvLtpdEirpQm9RQjWTq2t9o5BzYdsROxZ5LJvfq2P3r97zaZekOrJGvKrCseD44gV89k19CE12Ry3a3CvluUq+R8lYlYAv8DlnukPBLVUIoOHE2p/Wk/7D8h8t4u25GsEu+YXDnmkeckvEfS1SR034pzDILHZUeXfpMZKW3ziPfOCJyFvuc28FnHXMF8/+UPWDx7JcQCbUO7K8oGB7Q23m97cPUckeDfHmHnK6/rjoZr7FW1D0Tl197NLvzzGm3tEfbb43Vd1MfROeKmtYTcAYnBfG2j3TKWOR6QSUBg16fwd4RqPFHU/fGZQxt2tzWE3pIzpf4yXocZ0ZOidNLzm87RAdJhHt5GX1vGpXkaojVxrSipl7ytPxGT6dVYqRJY95RvhkY4w4IsiW95wr8+FdENQuQ7IrVPsWp9fsBcj3WEEygZWk49zUqe5RUPilNPkMIOC9Ae9ww1Qq7JoqJxm14j3fLv/jhAE/o3bCaKOjlv/48/bdhM10PCBbJWQCgeTRsISqA6FvAqtKt4Odhs41jo0egULSUeILT3rqadmXiVyaZMA94y8BPjln0sqTh+kA8GpwNepYL0YH3cB2WKzsQGpPTXotBMj0mkW
 AKCEdwW7
 iLJfjoATT5IY8lcdrYxTL9myBFLthEtATWOCxg7vs7O/VU4183M+PXLB+6koqQBu72E/AV7IeLT/KP1puenu9lLzpXyBvLm99pCu/ZvnqGY1MD/3CzZGJwyIMQL1e4wRqy3eaG5Bve1/40R0xGpw1H8Dz0sEqx2r9jmk4iO+NMYaoESjA98cZO+pb36Y4hr3AFYBenF5uVsYV6mxX1/uzLYRJZ4h+Y6TlkX84tLJbeZdomc32GGwxnwS1bGxxtDoezKYoBiNR8fXGEYByq8HzV9OHv0bpIasndobYdjg+1+PEVI7rPIs1yCTXjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.176.g3575e65682-goog


