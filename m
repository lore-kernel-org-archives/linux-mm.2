Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495F9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943138E000A; Wed, 27 Aug 2025 10:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3B78E0001; Wed, 27 Aug 2025 10:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2628E000A; Wed, 27 Aug 2025 10:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B088E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:47:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD5A21192D0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:47:55 +0000 (UTC)
X-FDA: 83822816910.25.8E7B338
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1818C0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:47:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O3mbVwcM;
	spf=pass (imf22.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756306073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13dITh5qMhTwgen5+ni1BGm3XxaFP16NS352Fgwalx0=;
	b=2ImjajUFXFnnpZhbLMdz1Eq5BWFlplLjN2IYQImFBs/IPDD73Leo4Gr90+XZtc9vwARC6N
	oCFkF3EctH/o8ccQZai8DJIbxk5+7s+GurEFIP/MCJEIQ46Zv19q8f2lfVu/ddQiicwAH9
	44iLKZ+JErMfYhsfxOr+YUVr1rCIB6c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O3mbVwcM;
	spf=pass (imf22.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756306073; a=rsa-sha256;
	cv=none;
	b=AFIQd+8PGAcrmker0sro+4uLVQ3cZuRzSOjMPepRQeKiZxKUOdWGx35GFc29r+6p40Z68q
	i/R3KCpogVkHhBGOa5k9prYqZsbCBbrwEHAS7BTT5obo5sH3wlGrTwDkt7XJd6HR9MEkx5
	1N8LxyZ6jLDDHbWppgMV5ItSJVc4ecc=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-771f3f89952so892104b3a.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756306073; x=1756910873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13dITh5qMhTwgen5+ni1BGm3XxaFP16NS352Fgwalx0=;
        b=O3mbVwcMHUgrgsth9Z0gs3mRWwgyA/NLmwZCxCDj8UvdujLBIP7cbF0jbIw4ccRNWc
         01RCXoO8Wdt7qJ4d8SCEBIzdn8JZdqaQSpXQQJC3zqbsxy/VjpjiHTOKwFo83p2BtCvy
         +cXVzcQT5j2EA+qKGBppRzR6A5LuEWMKx8BwZ/y7PhpSrXQ0Hu5IQpfKmc24YWVOvTE4
         Ck4fRxpDpbrt+7WzXIJfSYced44/L2iLNpfkDrt6pAe3yoob/a7azEBu7AgJ0NCJ+1Qr
         MmQl+9PRLDmPmlAKefcqcF3a8/NbvNlHeJVk9fqQzIBXqq4ptTalX99cSxPYQKFtwDdq
         V1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756306073; x=1756910873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13dITh5qMhTwgen5+ni1BGm3XxaFP16NS352Fgwalx0=;
        b=Wxh1FuQDPDQLC3KGrpAv/AcpriNy70w0eku4A3nCK2uBAEYVbjgh+36D2ajhYniKjb
         VB0durcL1k97dYJZrWQs/7/pP2E6cS560QDBDnkyF8B9LK0KqQPT1F7tzMUPxAr8BgKM
         g5aDIVary6uufym+0agHssJEzjP8EWeneSTMr3Xp9uYogiOcvfGb2inaCJBPQdzhUCcB
         dcXfNNyydoWrt5FVDmigG0uO1f9bA0yaKlJ4SJ3BDfsyW4MnfmRsnAOnuUjjJVxX8hvN
         jDyn+fLQqr1sJtRmd4DhRx2DhJf3e7DACYPs58oXs+z6lrt+I2dW09z0mIrLtKu0jlwp
         7+aw==
X-Forwarded-Encrypted: i=1; AJvYcCVhgkgIDqsobxp6Sl02C+NPlWh5kUgQHQUDRB6y7H45l8wCyMFQzQiU1P+Gt7DN6JXyT94LXl4RtQ==@kvack.org
X-Gm-Message-State: AOJu0YznVMrVjJUDVEHQY6Fu8bCshgP1wtN/FaPsdNdUQq0f8QShf+kH
	TKRwL+Ofxx5CxDu+/dvSX1ntOUs5/Rbz2CHe3VUofjEgTOQBmlwxvpCB
X-Gm-Gg: ASbGncvzik/jpsHMckH33mX/ShOj0Wd7Ud/hyqKWS+6dvXEEU8w0V4EU8sg3GHMoQKP
	GpbMzU9OfG0TznL27y0/JFNV8AlfRW5IwczsF4g3Lri++aycVfg4tOKkYvVgKMUyCpTh1oMT5Tb
	0zndhapXXIpnGnNN+etzuNA+R3LNiV3EohHDHYq1rWGBIWCbHGLGJqyzQ5RZdvHiupbIjqKJrNy
	8ISPFwS0tArFagDpgYpaJjBqAGpMqwPDDhnj9kH+MEY+hHdxgYTz7USAd8khJjovNEcY/X6xSWC
	dtMilYbpKC+ZA2knZBjBY/2UGNQvL+ieJHuKt2BEepx2SPsnn+saAbAnqKroT/moHup08QGDz6o
	/gSOl4WzTQxCb6jusJTGSN9yK/YSqw93Oao6jR0kLnVah0jcrzdvGc528kLxL/w/D+MjU+ixqoT
	8jRgmS7Px9+bRrm0miog==
X-Google-Smtp-Source: AGHT+IFtL9B/8t5NBH9ou3cP/RbYSbdJ+pfYeXe2gkqlkXerpdfCbiLigXMQwyjmc8h7AygyOx6V5Q==
X-Received: by 2002:a05:6a20:1585:b0:243:78a:82c3 with SMTP id adf61e73a8af0-2438facc6damr7647762637.24.1756306072497;
        Wed, 27 Aug 2025 07:47:52 -0700 (PDT)
Received: from server.. ([103.251.57.213])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7c09fsm11626826a12.26.2025.08.27.07.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 07:47:52 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: mic@digikod.net,
	gnoack@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	ming.lei@redhat.com,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-mm@kvack.org,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Subject: [PATCH 1/2] selftests: Centralize include path for kselftest.h and kselftest_harness.h
Date: Wed, 27 Aug 2025 20:17:32 +0530
Message-ID: <20250827144733.82277-2-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C1818C0005
X-Rspam-User: 
X-Stat-Signature: xdebrgzr19cydoqmo4dpuwgy4sk8e5dm
X-Rspamd-Server: rspam09
X-HE-Tag: 1756306073-326005
X-HE-Meta: U2FsdGVkX19MQdMuksPuXG5x0+RiJEHdPpSGV22CPYhhQozu4I3ddJoWvhUIt7zhKACuUoBjKvwU6n+MED9RH8QwHObKAH3g5/I84kFmbiREoDEsfgQZvqar9D1pg6+sNyRh8+suPPZKKfsowHH12QqkHVK/pgrQq6kXth4KTHBIxZ3mjfF24Ek/c8/Xa+HvMn3F1pYIikRFowQovvA4jnm8kemNU/22uhzPqqKm6fIzTgbxOvrEY0pzVE/ZWB7a/mfr9T4Vaz1uWmickhQ0emAcy9ismQNLHBn8MGuzB9M7Xr1g2SoubfJcVaU+zp6PWj0MnKOZ37idqxTQMz6FzSs5WC7Lp4chMN5PT4bR4ap8Ua5hnSUDQKQcAOFinikcbfO7Ye5U7yul/EVIpW9r+6lgR5NjSKnjHvHeTD3715/Q0WpaJ6DbuzoKfYQhViUCYQOSx4hI12j1FSMrOoSkTZSmf7MSfciCqreerNl2t1Zl7wllB6V1apsbUbytzha4TY4W9+0mGCv/H7pMr2puIItFKOEOKBjjfCPYMCJx5nQYcy/fgNUoNqdVd6DeJSYhmpB39AuZUgJVomyZSXOrWa40w67G0g9C2U3Eblv1dJgfYi8oF6SSfIb09dqaeO5z6rJ2W5HS2DoxvbowPPhFa+Qh2LbggGzxHM0uICVcWTvUrFMTiY12fUjBlH4buy7bdVNKi1uqtm96MF9Hmzabh2E50LyBs7bywMpptnUIfL1NPWMKEF+NnTSjrllhfp7BYwM7NtHpOuwK9R7AQY43A2+g7rC5LO8bLx65mdxzKpFkS+R7Uhayhcn5BpRecElSHTepWUGLiQp9bthkkrrdOQfTYTKgEAGxEi0EodrGOetqkNnvtwG7odlLbcgcTX5ek+CnZIoW+SQLXpMafBwgRWTbH/x+Aa0SwLOA4p9VzEixqCcwiVUs6fFY9P2uATKgoDv7vOdhe8k2dZthItE
 YaYiZNvw
 bZPtSmV5JYHcChS6otaYcovCKySS/JMn0B0Pven4gF8e8xXm0Zx1xdrrCZqtVcIykR7ZdmKBSDNfqv3dsyrXAsOUhUy2SmWdoYXk5lu9dgu7YNnraTKPDxcqR4hvYXKqtUl7/HLrASbgYGYGl2G2HXZzWv7s1h4HXX3bA+lu8EcmCmDz1bqofsdQFecjBENwrVc55l/pzq16QEuFWe8gx6JY3nNizeMll+VeRYKvG2BEVwo7quVRfKTESxXOtRtKW7UH0dwVklu4c1RH4LH7/YtyNxW4nWUUFXZJWYbBhW4Cvydb/B5BGk8ftOTBEaUs3NrgvkC3QkSrcgmmQUHlv29JA2pbPqq7PLLG0jh6Nmre7ZnPeNizaZHhharsBJ8UBWNmziqX8/iXC/4fCH31azetzGWg+s4sC2y+DaD2/LL9+ytOP1XIDZkQQ1DRHlRk7DwEgb/Gf/RpCaFE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add compile flag in Makefile and export it in lib.mk
Also add CFLAGS in sync/Makefile's rules to fix include path
error for kselftest.h.

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
---
 tools/testing/selftests/Makefile | 4 ++++
 tools/testing/selftests/lib.mk   | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 030da61dbff3..7c9db82a81e6 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -194,11 +194,15 @@ else
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
+# Include path for kselftest.h
+KSFT_INCLUDES := -I${abs_srctree}/tools/testing/selftests
+
 # Prepare for headers install
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export BUILD
 export KHDR_INCLUDES
+export KSFT_INCLUDES
 
 # set default goal to all, so make without a target runs all, even when
 # all isn't the first target in the file.
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 530390033929..50289b9a1e1d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -199,6 +199,8 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 # Build with _GNU_SOURCE by default
 CFLAGS += -D_GNU_SOURCE=
 
+CFLAGS += $(KSFT_INCLUDES)
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
-- 
2.43.0


