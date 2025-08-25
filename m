Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C438CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608C28E0034; Mon, 25 Aug 2025 10:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8E58E0001; Mon, 25 Aug 2025 10:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480E48E0034; Mon, 25 Aug 2025 10:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31C158E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3F99B9879
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:51 +0000 (UTC)
X-FDA: 83815584342.03.A7E8BDA
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25D8C1A000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XXRtTHAT;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
	b=KGf+TxSSeaH6hU4WBmf17OGYwBi3Nt4/rrz5TxlGvW2oqEE8qYssqCjMCr88a1sKPpy/li
	MxwfJs1lppYkSd8Qbo89gRdMN9q/UjKNL2uhfsHm2W6GMHzxzusamP3eUwgqdfDw+8863V
	arVfWCUD+5+xCRYHsThEF3C2p7maROk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133870; a=rsa-sha256;
	cv=none;
	b=s2ath22WBcIjlGdYYO9EAHiJnC96yiCeBHsGdp/rop86L6cdBTK2q5RrAzYnsDQyXf8YNH
	+ecDfectNvYXMuPV/0OrtTavQO1X7LakZiG/XsVkBCaMpIfjXKOheuudfM1HObt4OU+06g
	VujtJ2a7BgAgS3P3SyENkNTVCTrzuxg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XXRtTHAT;
	spf=pass (imf19.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e2e6038cfso4966883b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133869; x=1756738669; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
        b=XXRtTHATdsyw0n/wExeNkwzHtVUyFtxVsS3PkEvzWjNzLHD/HvUmiUq2+bVozJ8sOW
         EkZbZHXK1KpyIQ+1/rJYIxJ0g3FhLhW2XETMUWSY1qtIPt+9zXIFIeO8AeUmqndJJaQm
         ZXci7lkb6XpUt+7DsgYiZELq9lB1h2hfC/5PNo5dZhwjvGLkPR96ZeC5QfElIY/SS1b9
         mqDcNidl1igemy0KpLiudubjUEaYtiwCb3NR8EHOrs6CYltkzZg2mWYIhUbkGk60My4x
         MwxB4/Lx1Y3fa5jjt0F2opEGxAeKa19JBwqNnj5YZBH46CACXkkoyLJ4wIhDXGCUUrD6
         qYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133869; x=1756738669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4tDabwrjUnjyF2pNuKY+D/uJFltgF7p2tl2gzeMXdU=;
        b=kT5tKG3Dnm3XQ1HQsYYyZkhoUhkAtuoXSKtWgDQwmCive9Zn0Hoyh3UlGtmD0ByJ5l
         qykCf/ew/Z6sfnaXPwwERtjXBeKu17+lDe0naOJUEnqEPwWcb8UvrlaE02qYpSl4WW9R
         B1oE3OJol6pkoBuRe/fVCliSm/GjzvkIa/FkO2YlV/cO5DrLM0a8kDmli/ObxB8Y7B17
         875j+YV+onZ1ivFx1s8uJEEzLZs0WBU7RXfcxOVUvOSePCYSJvmIaMdLUyJ0keMs8hEi
         pB2NOYs8vEGIn6RfcBzaYxtdvTD9Dr46w1gyZJN4YQJYzkS5vfMsh2Y2hMIllZmQzBxi
         b3dw==
X-Forwarded-Encrypted: i=1; AJvYcCUWMugnRYU7RMbvgizkXo14YLnQuV4c6XUHhpASs0LwYLAtp9iwXUyL3ymxjq54fjkIaGZYdDPOgg==@kvack.org
X-Gm-Message-State: AOJu0YyA3PrhCNwW6ZDuu6qkqE8QJnPlxQWFZj3gkrSd+AZR7YMiEzsu
	ax1sbwcJJeYhWVHjzlbnot8mKzUoDUE4JhokN10Go+/7rkJ9mpgcs8ICLrsjE6Ww7CU=
X-Gm-Gg: ASbGncsJmmU8nI9fqdkLyl/e6sh9VficUAFG6Z842Vi5QRonUZEIhspcKd742ZYWgTt
	sY+v3XePY8OkrnsxsSjnii+V4GB4xzpfmVxBd8wBBs2rHjMkQAnECheX5rUj7dNCRX4QYzcqNGg
	fQtgYQeccyuRy4lVo0rkL0ZaQgYv8SFo0MHbSq664xnPFuegL5TRToXLDSthFA5EpfHvl3czvrc
	46FzfYODMBCvIizRFFdD3ae0XP4zcuCHph0lZdGCZT8Zv8hnp5xEueFFjC5zoDsxN0F64g4MDi0
	hBpScaS65el/z1c/OSfOvHgiyNf47abt1bkxlMM+Cyqzvdd1TUHxvUphd0vfSTOkiy6wXSeRqAj
	nDmSqRy1MsDJKAJeOCy3Xxw2lnn/uJqPveYqWu8Eo+ZvEEz/hjf7KlCmCt+to
X-Google-Smtp-Source: AGHT+IFQ75GZYr3N6HMX7zPn0dw0ZuYOLQe7vaWeVSJK+4VjzmhYfxDpWVGeXxn9RSIeBs/bIzorqg==
X-Received: by 2002:a05:6a00:248f:b0:770:34f9:49d2 with SMTP id d2e1a72fcca58-77034f94ca1mr11670084b3a.1.1756133868947;
        Mon, 25 Aug 2025 07:57:48 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:48 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mshare: selftests: Add test case ioctl unmap
Date: Mon, 25 Aug 2025 22:57:08 +0800
Message-Id: <20250825145719.29455-6-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25D8C1A000D
X-Stat-Signature: hzw4ft5cmkgz1p9i5yajzw6k1n64gxyt
X-Rspam-User: 
X-HE-Tag: 1756133869-252380
X-HE-Meta: U2FsdGVkX1/GXpVInh348xCycUQq3veWVL6hYb/hQ+v2HxJX/jlBwAy06KkXXUithHx7YmMdyePMRiY8eDS2+RQ189GSMwhfo+HDHKqQXoLxYteCRMTv+agrJj+1DuyUVMSwDf2u7uPnoFljLnqmTQELHKnM3BkT+h6gEy8fc3XKk0ff1eF7t985YkA4xnpqXlre34yKOtGg1FXbNAgMnEFN/Uo3Le0PVos/diPTMnHH9ekn2VDwiRnSmmRkwS/MBuYHkJsjSr4QtnPxhCf4Na+CUlkGUbcUTvfDHXMpZn5mbCtaSVYDirvtSVw5m9+nldLvrUrATo0bvY6LewdJYv5ZNxZgorjJGlkWfRCkcEm1c7UDJ4UGyeyFR0SHj91UfKwSWgkzf8ly0JGGj6lkg8E6FNLejgD/gH+UYD/Y1r10Yb8ztmpO7RCFr7GvM9Lw3faqT5Lzifde53DQqqFKz4SbDm+B15gfsWXrXNjCnus9wAC8XnvN2czf2WtU7Z50dfOqHtVY5O1FCxcNbC0tCJVNp60Z8B0TNWCuUYwHvswpXNnnVqSdiMMHBtWEsy+CHPmZn8tM9lDV6uzY1yljGpe4oxcktLs90H5TEN/K4Lv1nMqDoVwmPDfGA/A4Ncc9hliW5fTcIRCD5XrZZhQK/d4LULjGfYxx7vIDnLt88ScaCw6wnP18Li1ksPBDeehzJVM73BW27+q/Ger5QNysn5AympIlQun8un8adZRfcHK23rf4pZbNgSrw/245lYMLa1LmgsVdwp9dUWWeYg/7SGSLH4FPNfRAcloouew1ziGG6rOiOD+bvshZCUVfYUh9UizoljbIsu3+CsBgwuj35aXF3LOM31z2tqduPs2oWiEp49zFFVE+ogodJ+/jdmID09ejp87BD/QDTIFcnPRpZXxE0yx8s2BY3BDb2ipM2fVXhLkkRkhLClqvHcwYR4383vJ8CgJxATUvJjUy47M
 wPhhCG8P
 jpTQ8r5UEfnn7eBfLr49631G921PP+TxZolM5ydYlNir4tZBpc8Ic6KIBUG9US82JUMSZ4LVf50W05Psf/xiI9qdZz0XvMfBdqex+Pw3GHw/yPqq/P9hVsMcRv6yFn+DVIgJb3SOv2ocaHE7BtWTnTSUxUSyCFgFIrCBhk9SiodrLaW2Z16RrAVPAcu1PqoFiSCVvDwRH1wENeCy+LAVNadU3GkJ2rmGrLtLSqJ73Asv5qMPFS+ui030N7l7TEbPgRBxhcYtD6gqtcVMc8RRQPoXrBVB4HAO0njSlAspZSld/4KUvwwaS92MMqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case aims to verify whether the process with guest mm will
segfault when VMA of host mm is unmaped via ioctl(MSHAREFS_UNMAP).

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 2347d30adfee..16d1f63c3ebe 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -85,4 +85,24 @@ TEST_F(basic, shared_mem)
 	ASSERT_EQ(memcmp(addr, STRING, sizeof(STRING)), 0);
 }
 
+TEST_F_SIGNAL(basic, ioctl_unmap, SIGSEGV)
+{
+	char *addr;
+	int fd;
+
+	fd = open(self->filename, O_RDWR, 0600);
+	addr = mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
+			MAP_SHARED, fd, 0);
+	ASSERT_NE(addr, MAP_FAILED);
+	addr[0] = 'M';
+
+	/* munmap vma for host mm */
+	mshare_ioctl_munmap(fd, self->allocate_size);
+	/*
+	 * Will generate SIGSEGV signal as ioctl has already cleaned
+	 * shared page table
+	 */
+	addr[0] = 'D';
+}
+
 TEST_HARNESS_MAIN
-- 
2.20.1


