Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1E0CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B16D8E0030; Mon, 25 Aug 2025 10:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988E88E0001; Mon, 25 Aug 2025 10:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F118E0030; Mon, 25 Aug 2025 10:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7845E8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20F071A0461
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:37 +0000 (UTC)
X-FDA: 83815583754.16.7A97D86
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 296144000A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGoPIOnv;
	spf=pass (imf07.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133855; a=rsa-sha256;
	cv=none;
	b=Tlz0CvK22ti7Gu9jUoMjauChmEKTM1b5HPrQ6TpTmTrmpfRTBvM5GwcJ7UfY/9C/7X8u48
	s8DhurYdjltuBJR6GV2fTSKKqLi7PcjHq94Ml5pAqHfO5jwig+fEmC/3802pa/q3m5pviZ
	tWX8IFDQcf/lqlglbb3NbBzaS9g5N5g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGoPIOnv;
	spf=pass (imf07.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
	b=OMe6yf0YbwPwOMo79ETCELtJQeiMf/8rhvOyQnhFv8F7Hpnkw1kVZzbnWdfY+Y6wd/aiwj
	esgocL7EqMZB2JPrKAGv01x3tR7JOGa4nxBBItKVqeyNme2JWpNBr6K+apUG/oqhJXvm30
	fHgLonXtcyZ7cIhGC5ZzFEzDSVsuN4g=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-76e2eb6d07bso3775595b3a.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133854; x=1756738654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
        b=eGoPIOnv2IAHBWS1mmHqh+6CC2hUxKt38hiT6OJlCcWvI73b6HtLUU0jNr4E/gJJDs
         +hWJCiPZpyVtpa1O+BRip46q247lXHY2wkjFLO7sEBAhd/G/UIN1bLDC34q2UOFqBiOY
         5IoLDmdA89EvRT2E1Xe7zmJzR83Rh3b+NMHvvM7qjZLSAWMWEL6IzICAyS1hcbLma2Ju
         vzEa6fa013f/u1kkt4HH8rgf9QnkVGfxQWqoJnNfmZGsZI9gPJgHE8eefMwE+ttiyeVd
         JlE0dQqX4iq71gS/L6uDHzt1jOYjQWa8AraNSHOL35KxM2UqE+su1hMdsOfg+WL93Rn7
         6/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133854; x=1756738654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
        b=rDPW1lAleXD/ClDAsx51zxVoJSxvftZ9VlbSRjDBa/nGbyECXNMVMI0UHuTJYKk7sO
         W55PnWycibIu5RYy8m+/Wq8Qt1Lxbqx3wRT8W69c7C47Q0fHKIoGIjgVXBWsr7xAH6Sp
         aPLTVqR5yRa+8csusmtMFXFWtgabf/PmuzrzyKABd51CfE0vomR3lKLs5vhH98M6MA+1
         6zxcgKKw5Na9iGBOjRwJag1HubXkaZRrqJp2w9OZEb3GFHQqxEHgtEgcD6FSnVZu68+j
         Xmodi52lbTuOiQ0YWpESg47hz26X+XLPb+LKCftsKLyWq3IGEVBTr5UQtZMR9XzqAZG7
         mi8g==
X-Forwarded-Encrypted: i=1; AJvYcCV/zI+XSd573WLhstBM7gVlLNUdEkE6+mHT9rg6Cc2zcUFaitWEUDPBoVdiCcT97xpJIwzIb33gFQ==@kvack.org
X-Gm-Message-State: AOJu0YzMahsgTeGo7l2GWcFHwnvzgbIS4qpxYwpwAuozI3dIbt41BLXK
	3Ybn+EO6qYc70Co5ryrpf5h/rlRbX22+L0otP2oZzt+XEWo2aHX+Jb2ycErpi8/CqMQ=
X-Gm-Gg: ASbGnctGAegqKKuwseBdDSt6F4x04OOMytmFZnllyMTL0bVO9+FRkHKZOFzmWEsnd0u
	oKK9ggjEPRNmnGyFVDEEW2jlyql9FsmWwctJdEVKVZ9ngiPA1e76Pc+tBYURl7+jQr+hWi/WbrP
	Nk23JLJAuBLVRMNxAovnANZAZnLsxehZEXDLCX81+OdPcXcGYnb5NVnsC9zRL5JDAVrKfZVE/wb
	h2yOTJLBHC41Ede4uJE8Tn6yd8OaJkl91dVnlVFLyf4UIe4iGswUD5mFG0Bq/lCistTWKCJQbMI
	GFCOYxWDh2+Rh0wKqFD94FGpt2wkLpYrq/04hOf/SqdxFC7RZj2uKB0jSHWzOtE2Pe3u3zmCt7+
	Trt0fdAR+3GY3uJWKeihNr5CQWB3il2bf9MXuZD8wShTNhDWosH5NwAPYELlO
X-Google-Smtp-Source: AGHT+IHz+meFfe4e38cUw2IZHOaqrwBamHHnHRSOwdnH4MJHnCKcgOHroPbVyCsbXw3Co2hLg9rpTQ==
X-Received: by 2002:a05:6a00:3e01:b0:76e:885a:c33a with SMTP id d2e1a72fcca58-7702fc28b0cmr17435058b3a.32.1756133853573;
        Mon, 25 Aug 2025 07:57:33 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:33 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mshare: Add selftests
Date: Mon, 25 Aug 2025 22:57:04 +0800
Message-Id: <20250825145719.29455-2-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 296144000A
X-Stat-Signature: c7taa9errs4ozypkabj5cqnnbsi3btxt
X-Rspam-User: 
X-HE-Tag: 1756133854-436138
X-HE-Meta: U2FsdGVkX18BQSkLPb3/GOdy147nWM2eD6foq5VuRr7J8kro5SeQ5MEo3oY03pec4+Iinpwr3OQP+d71Q79EfPSPCiVI/ttZOoDX6gk63h+sHEweI+FjBKNMhy9WDFqFi1V9rAuJ2txelMRD8DZwFHwq7HSqeFAboEaD1JJJlXmLtmeuXTl9+fkMxQu/YarfBjl2EdBEx84tjgICS7z1so06EgY6n6uuuNjxwHn5c5pDpzdPG3eiSKF9NWgcJ1VNV3HOhcG70TvppHCZv8R3ov389feeNpejajnJO8gQncdjyPdLPaJ952jJbk27A6Yc3wLNRer+6Vf+6tuF8t+UrDDJHMD7PaJxnWIUM+delDhhJVUzfKw3COiIFlGCR8a+SCGS5B43hKQm9lfGvRBubZKS1Jn5dzzAPZQlttpQBO3QMtzr24IYlbLKpqQ5nghBxRl+yIV5HnYbzT5jBBWYr9NQASKCsXXTfFz1OhpYDKiPbdHZzRsx+L238rI1eQFoxlccDehzPJaNurwZ5UxClSjWNYXw5CF9HZuKqX9xu8QpJn+CTuAyPPGl0A07P9oivFFRdLH24/gwkvEZYLdHbp3lQzE0Q3opJyHnIda1N/cO23CuuMpXcX0DfSEcn2G/xird4/i3wvpbkB2sLNQY2jHsWYyX4W8yj9LAztfZmbZYh75TGnrFl/gK0yYRq5UOYWJdJ1rOk1+i06QYJYmQnjl4Op+hriFcyuMDjJV3bfFNWZTrXvnlWwTBDMwsvher+cxTAD779bOqW8FWjIv+9H+UW5tzGbZKVooxvD4623zn56EBF/NAUcH4fS3ovAunHmeoDCtd7Qfp7IjAtmB6uOopthPfkSLQ0rbSxIATa5xitL3h03tkao9ay0Jp+CVuNjT42a7UFUWrS3jiLJZT/gjPS658R3lLy5rlGqsx3H7L3B1RcVI6ZelJqwq67ZMFMNOqSbaOKM4R/4+wNba
 vu1nYA0z
 yeNrcnoi3c4yf3ie29I18n1sep8vMYC0C9yP5NbSUEb9UkC86wTE/zZri6A3UjRrjPwcBs5b6n9bypks+xVXE268e9S7ukmtZTJdtViHrqhs1Si7ErijR2Wc2WP+iM9I4iBQrB8e3cjLy5KmQJ+fD91Vwg62PzrHDK7ac7t0C/8adfpn7F8SEFBPFD4MdjNnQeao60POTPXgR/o8JRCdZ5wkJw0GlL/q5DLD46Y0jTPXD3FVh3ZqY+CBl6JgtkgDTEWNhYfW15N1t8Y+pzaIHXCT6/YhYRimx7P2kOnD1LwwxWmeghZPC6F2Nm1hxIybV+ZblOfkkqT+RpRnMX8QTzIzwSmZpved/xSABnSnMlg+iUx6qeHyW2zu3cobTZEZRCeiSO1lCPMbBFiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up the selftests project for mshare and add a
'hello world' to project.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/.gitignore |  3 +++
 tools/testing/selftests/mshare/Makefile   |  7 +++++++
 tools/testing/selftests/mshare/basic.c    | 10 ++++++++++
 3 files changed, 20 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/.gitignore
 create mode 100644 tools/testing/selftests/mshare/Makefile
 create mode 100644 tools/testing/selftests/mshare/basic.c

diff --git a/tools/testing/selftests/mshare/.gitignore b/tools/testing/selftests/mshare/.gitignore
new file mode 100644
index 000000000000..406f31bd432c
--- /dev/null
+++ b/tools/testing/selftests/mshare/.gitignore
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+basic
diff --git a/tools/testing/selftests/mshare/Makefile b/tools/testing/selftests/mshare/Makefile
new file mode 100644
index 000000000000..651658d091c5
--- /dev/null
+++ b/tools/testing/selftests/mshare/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CFLAGS = $(KHDR_INCLUDES) -Wall -g -O2
+
+TEST_GEN_PROGS := basic
+
+include ../lib.mk
diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
new file mode 100644
index 000000000000..482af948878d
--- /dev/null
+++ b/tools/testing/selftests/mshare/basic.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "../kselftest_harness.h"
+
+TEST(basic)
+{
+	printf("Hello mshare\n");
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1


