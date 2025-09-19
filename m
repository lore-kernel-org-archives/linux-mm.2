Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC0FCAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE948E001A; Fri, 19 Sep 2025 10:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7486B8E0019; Fri, 19 Sep 2025 10:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637908E001A; Fri, 19 Sep 2025 10:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4399C8E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1269F13B90E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:10 +0000 (UTC)
X-FDA: 83906305140.22.DBAB533
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FAB9C0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1PS+4x+;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqsEMj50XfHOshwHI2kqebsGSz4e9jnLx3tuTedHdO8=;
	b=8Z0HJfPE76+/eggHUwMV2eERViIzpidP6aZLBGvxyziWz83KERyUA7FK2qc+nyxv6XEGvL
	wLq8PgLxQhGl7xdLXC4/RqgNFvTIEfDPhX6JWZwroqgP7BKDdlADkQwuJkkRdrcmUwRiJW
	o4kjjGB78XepxUpLpo6z51mrMt1ho+M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1PS+4x+;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293888; a=rsa-sha256;
	cv=none;
	b=CLPnimJBjdQe24zIZghd8fRS7MaaT4Kgf2axFDK1xgu265oW65+pN6aw0oSyEglQLvxr99
	QhJdolYFfagK8826XAiFVnPkZxcegIISg3uchNTXj0S/SQDJBUmcM7OmxQRVuscaumlhqI
	GvcsYiRP9IGQGNxcBpn3+LQLD9VUeEI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3df15fdf0caso1979422f8f.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293887; x=1758898687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqsEMj50XfHOshwHI2kqebsGSz4e9jnLx3tuTedHdO8=;
        b=k1PS+4x+Oo/mHyeCF4d1nQZLn7t2t0vxtgzhu8t9gWe4rNAc9uGJ/IyeRvP8Cj75Yd
         z1iqmPF/izEKkmCM8UsWTeXcAuQeCqUB/q1bWeigMlGaBxTnUdm2QcZ6FcR7TJtbJZhf
         BoS9u0WDkHzOC5TzeH14WlLq13PUFou5sybRQIhEKPxlK6rn5wS3AK6WB1/V5BR+NJAY
         EppzKthUjoBN9JCsCaW/9t9zVBVnL9xl4rfgs2OQVwvhnytbOR5XUaIly6Wc99NnfWy0
         /22h+F8H6v6Bnoc7kHVvTzawVzCDZgUsqPAVacQ/BhUvWTJ9NFAZq1uCXlvh/+nacO5l
         s8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293887; x=1758898687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cqsEMj50XfHOshwHI2kqebsGSz4e9jnLx3tuTedHdO8=;
        b=WBoRlBWIBnvmo7I9Ye7avORRUp/1LlgiRSkg4Mv60EvdAPBF+kDhWxu6IclzGqCmW8
         6X4WilMhmDwXEQg9S81rqcSwb+2X4lA0C8oPO7x2qqI/IBzoqoCKWat7Wq0EDdkXTllk
         XOd8W41qYIEy8J/16o2JzeCh2jauKpX1zFcokC/oD3ttd9CKb8MJD2gY1eyUzfM0rX8q
         XymNCl82spVT6/rikkCfYbp7fXEtDXMGCelLUjFxm9pbCBMQb7oXyGY9nghAGIoDzDpx
         IOz24x4PVDE5SqqPSmWjH6IUNvBb9UYXThNYtRv6xouHl0261jFmRtprUWNBimUViYy5
         n3Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWy8gbRszZWYsP/WKfK9Kdu0L/P6NgS2T3lOZztF6so7KuBCX/o16ZaOnp9N7SFR73bQSA6qO2GFg==@kvack.org
X-Gm-Message-State: AOJu0Yx+V0hPQZ0qZl299GFBs+mL46JIZnP44+l5xsyRzxv2O+3cTYS3
	Otm/tD29CVv+zEsYFvavb0NijR7qUyHD3DOWEvpjg1z0Lb2f+iVX8aZX
X-Gm-Gg: ASbGncuV0pMBTkjzZWHiRkdno+s4UqLKDSxMA/a6CJkM9D13mHH6ZAcQ4BVwZd1g8EQ
	F+3KFThBy43RzYM9bayxbvh5MluxdcSaRidms1wM6bd7xPeFtsfZ7OTtmjWXb0NUIXH7nahs2H8
	KnY0C0P6/9Iid6CJljWOhUVM9n6/4CYToDtYEuHeOYP3vt5V1ePEx8ZPu5ff323tOCxl2bhVNNv
	26ng4kkfuTrKlBy94DB4CLFwZ4+QnX+rY60ZFtqXxuYd0/BD9FMYDbOCRBO4gTejzLETHHRXt5Q
	KNfeazifqVGR3NWAPcEpHPTeRHhDbrZCYiLb28Xb0tAKFTSt3/+KTDdTxOkiQImK/jWYwvJxbx/
	MPjI2odtPlq1yOEg9axGeI7Bj4NN5fDKxl0Q8jNo6YNQg+VjLlt4mWIdjVJJM7382tBX18H9hNI
	Tx+JDvsRhtoQQK4eA=
X-Google-Smtp-Source: AGHT+IEQGQ5Ibv5m+pzFfVuYC0xkpO2eoDLOdQC6WRoyuHEWEKPg7eRdhB1UiP1O9gJT0nbSt3KJMg==
X-Received: by 2002:a5d:584f:0:b0:3d1:61f0:d26c with SMTP id ffacd0b85a97d-3ee862edc77mr2891484f8f.54.1758293886534;
        Fri, 19 Sep 2025 07:58:06 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:06 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Fri, 19 Sep 2025 14:57:50 +0000
Message-ID: <20250919145750.3448393-11-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FAB9C0008
X-Rspamd-Server: rspam05
X-Stat-Signature: g3opjk47c7ctk5wjks4akprded89gbf1
X-Rspam-User: 
X-HE-Tag: 1758293887-779968
X-HE-Meta: U2FsdGVkX19MN/olHQxGN/4oQuJEDrycFwIUb+z1H7nHlVDhzWRFR1CoxT85ov9rr68R5LsVfDa432ydLikouzha2PcbHrRWxscJ0Jx5fZa55ZZMHH4taBNzA8Zg6dnAwD/SfpA0F0yv1eAfgcujCw7oHNMbg3j2bKcsu0kak/wDrjYaHo5VoevZ2CKs2Yh09OECvCLW3u8JduBkb+xIcl96gz49dEhqHO21OTwtBjIkwN+LkHmjVm4jRLTTprf6UevFmokCYyt3ps6UpXGsUmWRkAg7pme1ryuh0PnZZD7yE+OaZPH6p33ntV6eA4/FSsgL8M3EyEhrXE2Wx7Wxr9ypDLB+wv1G8qI+O+eutDE9+RRm+u3RwPrc/i6/F5eqMLZf8Jt3/sfAfDLIB99Z7EiB6ci2FT/CAPz37X6gSg2Uxhi/O674n4e0uftIknlgAwBSPy7J39o9GcYExZRxpJzmhjrjY+uHxPQBtlfjlTDSWZy12fDbprptj+ch5f3fdYdCb1zL3TZDys3E6YfPqcXBu7dl587zzwWKj7+itxe+5szt6caJmhbvrCd4zRvR5xdv1YK5eDbJ19tf3s9jBAV3VugOk5R+w0k1yIYzGyu+7AKL05HrJtdvIER1f06tRQhFjhOOcRmJvLckcj3R6g3bnDxvUvdVrbFCPZiL/KC+JD3qfjfBHx/icMuqaaHUkxm5d36FkXHEn6oQAwalS2UL6kaugqy3SiUaFjM5smD7256NXrsQSeHbZHCtgSeMhEPRia2IbT55LdoMbWXMakiUcPHcU5ngRCdhjI0TioKcK6oq+F9vYS9wdA/AD9bD3v/KIt0wv53LeJGmxdCuU6SSSJUHAGezRLxNGMxuLwgMauZUTmHP5RmRa+hfpxk7fmSdhloW8sPD1KUuGRXLVJCsWLE6H81L7r090C+ykdXkzqPor7KezbdWDHOdi6GBZMPEXVQw1Vn92XU5F4J
 uliRwD7u
 Cy/lryejDphwhLn7h5h/AcMHCXyloeWi56PschODnAYdO81QDJ0m8RUJ9W6Tp4CBAJDBz/4B0c9c1UbUJDd4VzSQMsmJIeT0gR8pgL05N0o3Pi3bAS4MvVNceTJAUMIRqfIvGNKX5w8cY/0B31fFupIkKHU97/rURzho1Vq1bgB69IgHjahJ9YeW4cG86VHto7jDvMwBi87uiT8Jz/iJzzmvp/zS9+GIaBr4K9QY1eUCw94pI0649uL/05R3a787Cu1y7A1xSYrzVZGiZwwoZm/tt6V2x57mVhFEs14EVM7Axxsgu0RpR2vWcym6pRVpBW0TlIPhB8qnYouMKs99t8un37rWITSq6ibRTja5Og1YX9jmU9eKqFIN14V+/ulNDZLmbfLUuvFgG6lfuLNadfaKO2Jh30NWCI9B7vEV0h4DkYLGlgmhnqicqLuZQgr7kTEDX5BUQjASCZGK08bNWgwG6EQNNumxhSZOHzU7HpxH4Ju9hnfHOKNN4s6QhOpHsoAsUfrtnZFxRLhTza6erEJ7OFtPTTVNzUU8sFcVWmSlPy2tZj5I1oKjq+hYlCO7QUnZwEgnXCL0F1g3CYQEE5x1msw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..14972e3e9d6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+F:  tools/kfuzztest-bridge/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0.470.ga7dc726c21-goog


