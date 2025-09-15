Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E855CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F188E000F; Mon, 15 Sep 2025 09:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C0B8E0001; Mon, 15 Sep 2025 09:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969618E000F; Mon, 15 Sep 2025 09:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80DD88E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51644C0570
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:50 +0000 (UTC)
X-FDA: 83891595060.30.647AD7E
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B63140011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J95bPOA4;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3k+HMxvoSODNJg+aOvvtyLIc8HnLU1Qgi5sDsLaNJTQ=;
	b=1iGQB8WzOdVze/9AqMJ96q9H3+ym7wCNunx9SJ2LpwuvL766gce2Jcu7378reNdPauNq2Y
	7jyQEoi3PClwy2qrpCM7skwXiHIiEN+nrPfGKFbn8Qp9EnWXvj5IjtiwQ/hzNOjWNg390a
	d9mft9YUI2hFU7UWwbZoUj+pmaMum6M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J95bPOA4;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943648; a=rsa-sha256;
	cv=none;
	b=G618QJhGmj1SqqYGuQ4xLoF3xI/zZRpnJ/kDvZg1QT747Hgtbf/A66jecTMkTXEBBz7WVb
	Hr+XCXuWc2YV+YCHW9aE6IyruDxsJJtqisjYLGo6ogB+tOPj4HUjVRJreApUe9GSQ4vOdL
	a5NhWSeGm/FOyadE3NKWx38LbWpw61c=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55f720ffe34so4781258e87.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943647; x=1758548447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3k+HMxvoSODNJg+aOvvtyLIc8HnLU1Qgi5sDsLaNJTQ=;
        b=J95bPOA4gYe5GM7p0sU2cjrBE8O53sfDwxrUgCIxnK2lbi/Ne7qnjAA3W2dnv03dXH
         trUHfX7eyrXzNfFg7GyVP3EqHQyr4wnLk2jImea47jWtbY+MiSRrZcj7qUhRUKFBjTR9
         6fGJId/vnZYwR92qGXQOio0ZrcmlRs8mPgxO5qra5c6EV7qrNGxJS8EK3pDnUFEju+YJ
         fKsKwvgqVyAhWvifMNnfLuFBwhOpQ3XGPWhP/M4lBCLU9LzHiE3fYSM96SLc1rDY/x9A
         HWsYrLSFTF356kdXB2WFsFJFHpjst05/Ie8NxD/0WfF4awwsBCNNq2nFPECuuQUO1lg+
         mITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943647; x=1758548447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3k+HMxvoSODNJg+aOvvtyLIc8HnLU1Qgi5sDsLaNJTQ=;
        b=aU7n2V+Jv5lY1D/YtW4KiSw1J16jQ/FBUbglB6wF00yP1o/fGSLnOANpSHuooSUXJf
         wRDBEBxXBgez31LMwBe/nXV1YEl+iA1VDeXsixIoe8gvpHaK/XMqIN31zunI3wtmOuoG
         xq5JGfWyaee4dNAyVnWZSco+svq/8iY/IjjYd4M62qxOrm2DS7Ynx3BpZ95PVHGwr/p+
         n1iHBciOFY5vvpN+ykVxjbn+p1RFdzo6dXUitYCsdJ64kDxxMM3i9QhELotDgkBb1VFv
         SVkyoNTja7inqnBxDnhJKXy4ridaYooRkq8i99d9JWhptwqPcKNkih8R0NDD/HlPWnCm
         vZ2Q==
X-Gm-Message-State: AOJu0Yxj6QpuvSrAE7X6agEvaTBNz3ukAncRBabSMi0c0CJhUjwhcxX/
	PZ88IVmhzQDiAUg5I2kkk9itHfVoptW3ucldY1lcfFi6V/1o4Rlqjxz9TZxPwg==
X-Gm-Gg: ASbGncvQJMVlID/gIdAV6wIJcLRhl8vK/2bo9SWiyQeLNMgXJt6G36ttVJnloGKBrOT
	950Np5fIW6EhFwoh3q30FjMxqUpf2pk3ItoZCsxJ5PSbWurXE4e9AgBnGnwlor0OXL9k+H1//+q
	20VJ/QgGgvq4VpvDMoFpq21P+TZqu13EsMXYuFZSanSb1qr8OY8ta7o0BbUpbEJ2UHNgkVOEeTO
	OLVtylwdz5oNH4ftc7T7S5H1a/Rj0tc3EM/5/gYnDFl1yTtuv8DhkaoMAsvko304yTK2oRIUoKh
	wgCALWNi3FzX3RywrrfHvzVz6yssktZHboH5Xm0qIfQgBBmwL3/RabCImIMxUZZjlAOHsr239o5
	EA4cddp3kYDrLNnokIIZD6Y0AshQ=
X-Google-Smtp-Source: AGHT+IERKcOtfpXRTiN0QLo0iio7095LVUAyN+kLUsrBNmWW6XKvJmTj2p0WgeUQPLxrRtNOxCYwTw==
X-Received: by 2002:a05:6512:ac8:b0:55f:3ae4:fe57 with SMTP id 2adb3069b0e04-5706133eb11mr3302428e87.20.1757943646550;
        Mon, 15 Sep 2025 06:40:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:46 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking is not permitted
Date: Mon, 15 Sep 2025 15:40:34 +0200
Message-ID: <20250915134041.151462-5-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1cwoembgiwiwjt4fo5s7xb15ers7h7sm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B63140011
X-Rspamd-Server: rspam04
X-HE-Tag: 1757943648-121313
X-HE-Meta: U2FsdGVkX1/NKSx6ZzREVQcqxplJje0kf7jGx4CVpJDyz1m7vQ7yY10+W9k0HyeuQJ58H/Sj5IjWB8Cf4Mz7RyxdkwxEVlhxUnLGYpItzK1Paqjx0AG4W76wfidAccu43w0eIvEQnLQA/Uuo/kS4eSFtduN7vFiuxxXDsf2hrgm3qSU0rwgddlNx6fkehTYrGwxCBKN5UQLwVz7m0EmscANZ2RYFPL2KKAndCP0FwR+UEfKzPGmOFkP0ChqukvUKTM4BgLcC1vdwU/jYXvdaPPQEswLfHXIkeBcjd3odOvf6NbdF9yrxTJYCnNygWpFU/T6j12oh6rksVCRPTYPDWcv+yvYpFt0FLIjR2E/stItv3wJSVDbgZNeYHpNhlvp5Y0j55xdAUqvFvy9nH9eD5wHkOAy9eahtYIsuyfMf7s3WrmXdmKduJZNtHPNygKYKfZ0AO5qx06kvrvBQaFx8qDwNUFZPIgWeFe+Ycu2UAHPFWZdt2+XOkQ3wQdOEOK/cNS1GxrcMJaLxZu8LpOM0cCb76oO832FkQaneQkyUs+lv8t6TClvI2UQuDd2GnC6PZrf3261be6bsTEqdSo0WekKZBHkXED29ACZPJMp7NmBALSlxfKLBJJAte/ewf6Vvb6U7SWAkHJgFWShoJpyQADIAJmq+495JEvPKkgyyPpt1dKLcG2s98t4yP4aegft4SHn8XS8/ESL1nw7bgxZenXpDCKVdVYlJZhws9N/riorARRBlJO1FWojjUyzLWiB/0uHT9FDI/t+0ANOkptc1eDbvRfOHkV6cTghvb7GodMCHl5qhm8dTxEQD1GHEzy5mIgqxKuPlEYKkvwCNaAHwvVhnX/MYcOGerqcOGTjHOA0oLvK6Cmh1SFTQll3NrrgROsCw6KpFQx3PivMSJta8qnreflLApdqomSEbvkzEZmw9da/v45DV1RLNLhlo9uPkRMaEb9Hx3vRKR3pLzef
 WdAeSbpZ
 LkzhOj8kVsADwA078fEm2nDl/FW3R3cgKMMlTS3lFspehy5PYBOOdU+Y62CkAiSz0f/GA2sJB44SzSp1M0o8ekZc6kub9U/yOPmYqshLvazjKfQw7E8A+kqK+UXCGiSYCycQvWChldaxNVFf4GcNEEvgvp3pkkg8QMmLvKfmiKm41eaLy4WKmseANN8jrvHYF1YPD+r/Liv5G95tjhm/oKMGFKzpdQUMQpdqh6x8KjEVm+yO1zAbDCgCinSNFnBa40yed9TZviuWu/4OCITn4rVI+WY3VwpbBdOuT3nCl3aUwhudAMjOCTTTiTDpPcAmRbShT2TVa7+dgf3tYHPrZeRfej0zk135CUXlJf1vBJQxPAdRpNN692Z0olP8B0WYDAa1So5eXrabkUclfrF+cFyi1UZgWOQW706b7R7coztAkxRvCuG/q0vA9h8zBuL1YwiQVYjSypz9/V6EgMtg1S3/9DhH+6ky4xROwcvvBs03WV/xlT1KwyE04Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() contains the only voluntary reschedule points
along vmalloc() allocation path. They are needed to ensure forward
progress on PREEMPT_NONE kernels under contention for vmap metadata
(e.g. alloc_vmap_area()).

However, yielding should only be done if the given GFP flags allow
blocking. This patch avoids calling cond_resched() when allocation
context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 49a0f81930a8..b77e8be75f10 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3633,7 +3633,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			nr_allocated += nr;
-			cond_resched();
+
+			if (gfpflags_allow_blocking(gfp))
+				cond_resched();
 
 			/*
 			 * If zero or pages were obtained partly,
@@ -3675,7 +3677,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		cond_resched();
+		if (gfpflags_allow_blocking(gfp))
+			cond_resched();
+
 		nr_allocated += 1U << order;
 	}
 
-- 
2.47.3


