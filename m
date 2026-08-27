Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AC0C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6368F6B0088; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598A26B0096; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE1D6B0088; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3FB6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:25:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FB88120464
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:25:29 +0000 (UTC)
X-FDA: 85147423578.19.110A591
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id A3AAE8000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:25:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pWV1ohcQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of hnkz.64@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787844327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flL6svFl5aWrkKlDeo/jWDXl1QN2synua0XBk3WWZZg=;
	b=kTk/NngE10lLYVpjr4Z/vi+05otylTrNWrik2kQfaafaCI+NcWXP/6rTqTwgR/jEg9IJpD
	HH3Ye6H5jhx7yq6tFzqSJ3uA2mG1/ZBjOBUe30oWdsFgHBY/s1xd2AfchTkqWSZZN3hrhw
	Uu0rOZoroE05ZMqsJljQPvBjpgXn7tE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pWV1ohcQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of hnkz.64@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787844327;
	b=QQ9BqLjBAHnX/xRr5MS+BnSGdciWbYSabDXTysQSs33K+UNczIO/WXdMsmoLuj3V6Vh3V0
	mE2b6vSd6Tb+NgxS/pnE6FivmPx1Shgk2vM5TD3uUgi6jgTcf2yG3fO10l25yHFj21n+o5
	PNe6tIxUTiMnsQAjTZWuXf/65QotV4c=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8541875f596so17808b3a.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787844326; x=1788449126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=flL6svFl5aWrkKlDeo/jWDXl1QN2synua0XBk3WWZZg=;
        b=pWV1ohcQD1bl1vVgRZWtnSWpwQubWNTdHwLFuVkGqF0l1yCgD6L0oDbeBwstW9Hm4S
         1lrUUJC2fjZUgjzERHvlXHD6Zjcj1meex5g/HtkpUd+A/WFBe7J8XmAaWc72URX5vZxa
         lHXyxchJs2f5+mN4I1a2GfAHJ+r39/24eJFbn4Om64jwFt5uD1qGf4DZEwOiXtg2PE8D
         lilkwn7EqD17HWxkKJIcQpQZB4ntELvmfdH6wF0sHo9SQ9gNnUMh+P5AoCWCBtaf4XG7
         5K0mkkBOabBXUZeNUk1wmUykSuXPrKg8+h1BeWfUa3iB/ByNgB2S+4ohU/L/wqLLdMO2
         PpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787844326; x=1788449126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=flL6svFl5aWrkKlDeo/jWDXl1QN2synua0XBk3WWZZg=;
        b=K6sEFzWJ+z/6iFb4jl+D28riCRT41H1w5EgCqp5stow0+6ZhrLEIgtCAtZeoxzuA2W
         VIXcaeSS+GwqMa4BuFPyfTynMiuHcprs/aIGLwNGZeCup0U9jRLL0bYVSi5byEWxR2DJ
         wC0PcVR7arCEZwlyuTMGaF6VsZD7rhv5Ln/StWRBKnk6AqvvkoNp0tW+8D6kKsrYb3gb
         ltclBB8ejKwRJq1d4YBRiWTuIGdSPastIfe0NqA2I7rcadWm6I4f3NG6y+aYnBkAnA7Z
         YwGtOU1dY28f4tA3yJ/G0GcruEtS+7eR6ffNMYCAxIS8hIn1x4792Z7YOcWn3MWGB7V8
         iE4A==
X-Forwarded-Encrypted: i=1; AHgh+RoOxAWr+uFXq5qCz1bS1egSMB3D0ebpjpWEIJopmpSlQ/tyg+Z/F2sc5MALWUUVvtX/fVyWAQMmOQ==@kvack.org
X-Gm-Message-State: AFuF++lKFdiyAnQCJfZLx3aBmCJicYpUJohWWjVMC/dQeGvHeVX9tiEH
	8sJKriPWRz7tshmSvP5jow3v/7hIRQgTPjVhin0QMdmjGGHpoIhWRelzlODOasVn
X-Gm-Gg: AR+sD10bdh9cMOwEW4jAGIY2q6ZP7KJCxWNTK12Ho/qapp0ARyJMNR2x+O/JexD75bA
	frOJATHkKXUEr/Ywdm+mA5L54BRku0FCjaU1BPXC8J0wHU2ajPsdif3ZVUP+SdqC08pvoiXEQQy
	AXkROTgUfw7b8S3rOHUY552ug1PTvrudRuUCANLhJFQNvJ7E7tyUe2bPnjftycaEFZ3znAXwTpX
	/P8DjKZnkv+3NK2t5AOpbrRFebHTTElPABs9/fGdWMQaTaeVvGs9JM0CqNCV4AbFOibfTVBRzcV
	BrrvY6xZ+IVXw2AY1fnOL9SNmROer5YvfubKZUobKQ1KAcroLw+54lYWsiYL524nltR+EXt1qUo
	bZq4WTVXCxeLlrLmT1D05C3K9AYkJ8HTgxVQTAoU2cxA9bWXPFda6n7A6xIDETHUhpRW0Gd1XUC
	3fDGWHBMkLw6TRdur3sh28NSgKFLZJp/wyAFbAHQwOVDVnI3l+3UJy/FgTuPXAwRxmvLpEgkkya
	1VPRys8rY6NWPZFShe/RxbTBDWuVhftmrQHgA2z0BBlQEvmGxiFSw==
X-Received: by 2002:a05:6a00:17a3:b0:842:5b66:3c7f with SMTP id d2e1a72fcca58-85625842e10mr135248b3a.0.1787844326328;
        Thu, 27 Aug 2026 08:25:26 -0700 (PDT)
Received: from hnkz-ubuntu-vm1.mshome.net (flh4-125-195-69-140.tky.mesh.ad.jp. [125.195.69.140])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8535a8b8ce7sm2174914b3a.21.2026.08.27.08.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 08:25:25 -0700 (PDT)
From: Kazuki Hanai <hnkz.64@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Kazuki Hanai <hnkz.64@gmail.com>
Subject: [PATCH v2] tmpfs: fix unicode_map leaks in casefold option handling
Date: Fri, 28 Aug 2026 00:25:16 +0900
Message-ID: <20260827152516.805622-1-hnkz.64@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827151426.796843-1-hnkz.64@gmail.com>
References: <20260827151426.796843-1-hnkz.64@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3AAE8000A
X-Stat-Signature: 5cxdc9ndjhhr44piyf5u34kiqr3b3ob8
X-Rspam-User: 
X-HE-Tag: 1787844327-115302
X-HE-Meta: U2FsdGVkX1/s/rB6JjB3ciSgNiykzbjf6J4y9tNA7ZAdgocwie1cgqyXw9o8b/mTU//rnGm8RATANSNRmUJi29w9jkSXEUr4Xho153mjL5GCzjB+taK1OqIh90kPI3ERWbChyFkREM0ZWASBx23gFL7kvtuZOLDEABi889q4acuZkKVKXpH+gu4yb6PKjXzTLze2xARYpKVdk1dHJNzlw5xgvBAf+Wpq6UST6GqFzfoh8KhNzI0zrf0krCcm/iYcR1uSEAcfAZUfYbVQjZLKzKufQkRdk2M3g4ymz0WZCY8e86XrBXvqv1ADnDcJ6LjmRO9L9Au7fSw/5iQ/lCvc+KbWpz5JOTdO2ZtBVWPIYvtCN12evyl2CvyYiVE2mb1DZ9+wZeTDgxsSHv/XlhNbglB9WzVcbJZ9e2x2KdhyDUSmM6bhZWEHKKzBQwudDrLloKEiNaIpo4xlBmU8mUCntZF5elbW8bGwyogKGHquUFGK0TT4KuEkmXam1NpHpEq6g5bYmn4lnQvTvRK/ZGIIuBR2EI/ZPx6kW8aFvy7ftTPLahjrqnY66FEnALQWx+YfmZjEqlAirXapWDYuMjH1whD639G7D4PaotAZT6EEFLbM5sSftTGRgsy6DKetPIk/1gU0v81dj7kQ6Yav1obw7KS92Bw1irBKyvMyvyRAqm1K3ALRHjvPhjmMvNBCyKd5yOGGKzAVZmCzi89JrwmBqIBEZtmCh6SkWE/iud2Fa8vKWDOgp/G1YSlH2Sq9DrM8gOvsRJ+xtSKDws7chMw2mdUUMGM/ngzh7qSUaKD/0lFyP7xgph7aOxak10DW++D20oXfwYIrq0xD1hAKdH1MOeZilYQfl7ezutGxkN8VCTaAP9wxIw7LiU2Wg4V7ullOcHeOuA06qMe70r9GNUGn0/YX0+RYyK4GqY1Yc+obF1dUuRwJAVoOXEPQvLzSXXZ6kII35XMVIqnZPGfZ9G5
 mNZMD4Uv
 QkpVj4IjyFxENlESDKh4CrEOqurmr4qNxb8a9GTnx317bq1cKifZayXHXgzVcHtSj8sZrD8quIcnWBhVdI2C7p/mOcUKALeeSsepn25htzzhb2z+SM6mHoKHBluUUQrHXjg0VqU8XxDjg/VUO3uKAWHDD6GHfx1v6rAPlgvaASBjiOh6fExZ/jWYKyXP4XFk4nQWdepW8VCxUv9zkhJHJe8+tpPNjXU2B4P/mj4F1wxSs2/6whef3ofPYyYUbOiw9pZGO9PazyXBMAfGSzPEu1WJrO59DZ1k8+IYBYqIT2klxFUfwkYPQHM83KJXzL4Gi3SQVtuMR1RKcPGL6vcO/4iEZssYVEcAl34DYzrc2dYI/83LUpHY+bP7FJYli2QoguoOCmcQdrcrV4T4FwDm4R3+kxvxlRZ3TYqJmj86uL2bEYPRWHyGjKFO/bZJHY9GY8cS8o/gAhWIw+nn+B9b4fj4ukGoj5g7lyqVn1Oy01BTd8JDsZ5N88sBjPyNZ6m2UU0lVGwt0ZgtpsO8nDPZus7GF1s9TAXu+kk9YSRe3LSGxgKiJzZMNxm/D+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_parse_opt_casefold() stores the unicode_map returned by
utf8_load() in ctx->encoding. The casefold parameter can be supplied
more than once for the same filesystem context, but replacing the
stored map does not release the previous reference.

The final reference is also leaked when an unmounted filesystem
context is freed.

Release the previous map before replacing it, clear ctx->encoding
after transferring ownership to the superblock, and release any
remaining reference from shmem_free_fc().

An unprivileged user can repeatedly set the casefold parameter on a
tmpfs filesystem context from a user namespace. This causes
unbounded kernel memory consumption and can result in a local denial
of service.

Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Cc: stable@vger.kernel.org
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
---
Changes in v2:
- Keep Fixes, Cc, and Signed-off-by in a single trailer block.

 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 89a1495e55f7..62440caf2df5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4508,6 +4508,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
 		unicode_major(version), unicode_minor(version), unicode_rev(version));
 
+	utf8_unload(ctx->encoding);
 	ctx->encoding = encoding;
 
 	return 0;
@@ -4976,6 +4977,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5073,6 +5075,9 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0


