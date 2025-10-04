Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D50CCAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 21:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CF28E0006; Sat,  4 Oct 2025 17:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6344F8E0002; Sat,  4 Oct 2025 17:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522C18E0006; Sat,  4 Oct 2025 17:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B06C8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 17:47:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0562C021B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 21:47:35 +0000 (UTC)
X-FDA: 83961768870.25.3A66DE5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8545160008
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 21:47:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JgnQLq6q;
	spf=pass (imf08.hostedemail.com: domain of madhurkumar004@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=madhurkumar004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759614453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
	b=wYAR2O9ssmgFLKgX2NlqZgWPEp8kCd5p/tC9soryXgDZTWLANSXj4Z+I/JU1XTEboHbXPN
	VI3CbLkx288nK6T/dn3CfPHyxvb6YXUzDacX2WJwX5YxcrhqxhUR+VQXWSWAzWbzoIZF6G
	FMj7Y1Fo8oppjSctg64AFrh64UhukX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759614453; a=rsa-sha256;
	cv=none;
	b=m5w+rO6tVhtWa5i4JuIDp4WYcW1ByUdcU8mkGExTgImhPrOikYt8ph3gDet72J0zPOK1Pf
	KoEVNh7nNdP3ni+TXFTZj5LvdZ+KgyNv0gwYIsN0pWTYM8FBiwxDaUw93sTrsFNmV2hYZR
	2oqwGD1XktdlBryjULAcxE9HzpJFi5E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JgnQLq6q;
	spf=pass (imf08.hostedemail.com: domain of madhurkumar004@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=madhurkumar004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7835321bc98so3475440b3a.2
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 14:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759614453; x=1760219253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
        b=JgnQLq6qt8meLFkFLkxt/kNMefONUAfDgo7bW9Jgr70lPSGuOKjzwSq6bexL6S2dVA
         y4uAnLAm4vkxInAB6SLRkykDl5N274etxfAhADomXQTRsA/aQxXsqP6TLOgNc2+Bwl2m
         0yrndO3Ctyx2QyMtGYp+m9YQFippJ2oQL8bVT4JNFOgFmPYpKukeMgtW2PjY2Eg0PqH1
         Iis4oiLERQaLoGn04RNesBN5VBpuerdHbjdAJCP8g90DNmqxwev4jKCyXtLY5spsHyMN
         +VZy97cCKaBY5j9lYz7NMTAwKRRyHRIJLEIfynIul9x3+0qcda+HwGTQkTmhOfnnvkng
         m6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759614453; x=1760219253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
        b=xF3Ib9Ndrd9VISUTp4JL27CU7nYRa9fbGA3r8OCkukS3R4f7zd66iVGaBacBPN+jl4
         xIemMN6KlVu1FmlX/nFWwrBR1SFSRgo/dOCeIlclYeqtdKwlYvDpcnA6XMOOn7lW3s12
         snEdZToZ/vjF+lFqZ14u1nV2rcCk9lfOqwh/sKf7JMiqA++ghS2P3YFUI84D/AEW9AgY
         aHDdMXIRhHVs4I4m7zw67QavNiZek3VwUa5MiHJpk8DmZGK+ru7gMe84oesuw2/EG+bi
         o+2Ix7ql+MYQgs2SX+1yPbbwTmO+lpO8BnZ991vjOMkAAVsvicrFAqTwj9fU3AFR9Pr0
         EqtA==
X-Forwarded-Encrypted: i=1; AJvYcCUt/KlMvApvmfLdpc+8q8HNCymIsTQp0Xe0UjZfBthN/CevzhCx5ozFxhisP5ffqN+0I2gHREYtqA==@kvack.org
X-Gm-Message-State: AOJu0YzUYZFBhA8xJVdjOoxdjque6TkH+i/wdNFI45NPTaMWth6LRuSi
	yw5reLbBau2SnAQxPjFZcf+jbXyzXDAHpkMVHKvJhhUmbqV/gNP7cGR+
X-Gm-Gg: ASbGncsYq1PuLJx7fXXB6/mW3zVXs9XE53FKcP8jCTxUazv6LQ0HBJzl27j2/OOELXx
	rEDmiMt6AbGxwxRup2L3cwMR7fdwDHra9tm+GrV1cx8kboqWrqD3Kyg8LOAt4RJwCAyDuc0oOxX
	3OHiQUeqSSnclM1Ibdd0O6Xc3bbYmPE8uTDqLjW7x/WzXYUxXHJq7cujyK99MlGcKEYHO/y/gXY
	ld22Rbr7Iq5o452E1Vr/+Wvj4cTYWlJ71m1SsGRf3uoX5UAAoUwGU5bkTUeAHv+dX/dtW1vQVzy
	vnUEmQYiBkJUOTZVal68FH3k9oHRcIGboI2qs8lE9Rqnz/7GmXzC7fkiIf1n9wuIQyQpRaE049/
	+Tws6paHYOrqTFwRKOw0VH/61nTwdu/4CG+7mtXrU8qbGrfEw3a2cmGMe3H8=
X-Google-Smtp-Source: AGHT+IGz6mhFK6fAuTtELr1lJpt66OJ1dv0uue/uWlvY8bvgOy1dnpl3I6auqwtpvKyYMtmKCTi39A==
X-Received: by 2002:a05:6300:210d:b0:2b6:3182:be1e with SMTP id adf61e73a8af0-32b61dfbde9mr9335033637.12.1759614452275;
        Sat, 04 Oct 2025 14:47:32 -0700 (PDT)
Received: from archlinux ([36.255.84.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0209005asm8614408b3a.81.2025.10.04.14.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 14:47:31 -0700 (PDT)
From: Madhur Kumar <madhurkumar004@gmail.com>
To: nphamcs@gmail.com,
	hannes@cmpxchg.org,
	shuah@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhur Kumar <madhurkumar004@gmail.com>
Subject: [PATCH RESEND] selftests/cachestat: add tmpshmcstat file to .gitignore
Date: Sun,  5 Oct 2025 03:17:23 +0530
Message-ID: <20251004214723.1827194-1-madhurkumar004@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1jkbhosf3jp8u159ryxu97aqmmqd5jbi
X-Rspamd-Queue-Id: D8545160008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759614453-861950
X-HE-Meta: U2FsdGVkX1/NsPQB72bI+lV6BAus0+FAQldsTReM0vGLTVTMP55Eyzxug25gPk6o6zhCa8GCQ9unyM7TJN/X45j37Z5kbVOs2PV1J3RyaJjf9Lh6lLE/uyDsJVpBkCuhtuw+sLE8oCAjl2U8TpwtV4cxC8FY+qTlk4cydi5y2QS73nYRMIUXZis11wYN6ol0h4eb0NXFATERJjH0eQLDOYu2OzqwgpyTT9cAZzSMc+tnSpUfD/5Pk++wmWrmg9vG1EeebC830N1YS54i4VvV1g4mCvhUupXlrgV2DNKBptYaZF2UMAqKEkV9A1nRh82WVqYzFoXffeagwmRHOhHivGNR8CjmUd3yjCS/CxTAR/4Vt7Vxft9IZ32lcgSfwKep1N4seBApgkYPj92cZ3doWBCpY82AW6t3nP/tt+FbB+8/CH3mKh88i2Y+B9a1/QzdsgnGAvQpgvSafqjACSqD2wXnOl2DLHBGq/2fXG5Pnmc7+Y+npiWZqmC4CBrV98YRnq1Gxwf68M1Qa7Z7Koceo0eIAI3FIWpg945eZI+sgR5gR3ugLlSU5GtmVr6940+mf+ArgX8Z3lZKbcZXyQYasyovL03x/5FP4yQOtEAEnkU2bPwU/DIkY3kQIyFdkOPrEbHivR+uDUHj3dTjppQ8regkqYa5435w32S09rSkY0qxLwdqQI2O10pXIW+xnJ5bXFvQ5kTWOEmvIyzDphp1AFQmxXf5UgGz/AizpGBNawBtDDX+4DDztQnufeYVh7Q4p62kjJ3bbsAXVabgyfBSE7m241Bh+6R0wSnCoZUGQPSOEvdD5CBUk+8c0VO2AodqA+Wt2U1TW3Q6/zVI5Cnidv5aLsmCwCpa+71ejKcyB1nI1L/qC+fScWpbeorn9kjApRPC+0IhVe0FCS1ETQAS/MK9xBkglmXqBPQ4MUd8drG41WBAEv9ne/fPzFOQG3h2c9ahQROFEBdFokPHT+2
 ryjlfbiY
 jzyj0p1LUrxv3m2x1GyxWBieb9ivXgwQuppbu/rU1G6SSftqE6btBuU4y3UEhCWUtHsos4oMGjXFvS2maKvC+69Tql8TNZUyqcW1VVBHadMfGgPdXX+CS4YX0eIFMSvODMbqd+rEC+h4UG727WRrRaNsvEWFyj76iCX+uFfxdePaQ/gtGV2ONawp4zsx046rcWn0SbZXLaM2sdCghlKOVXoo3tHdPiByjT1DFyiyTQObJBWCr7SUC3I2oozaeTSvES8tBSyfy+7YJZ2ifVHYaw5V8Z/3nAihmFA9oKjrTrGjLX2HSXbeuylvj3gp5pTVAgMoyxnWYu4regdAHH7KbUQszfV3sO9iW1fbK0L9ckkPEPzGXXBiJZipyvBRLyxiySMrm316YvZneWiQsh60QXVVIJb3UlqVm7Z61ehK0+RcVf5ck4Wr84LRLpHSZe8LL/ZRoC2/u3Z9oeEhF1tTj2YJ3QQ77rM9Dm0QNCHNq4ZmvxQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the tmpshmcstat file to .gitignore to avoid
accidentally staging the build artifact

Signed-off-by: Madhur Kumar <madhurkumar004@gmail.com>
---
 tools/testing/selftests/cachestat/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cachestat/.gitignore b/tools/testing/selftests/cachestat/.gitignore
index d6c30b43a4bb..abbb13b6e96b 100644
--- a/tools/testing/selftests/cachestat/.gitignore
+++ b/tools/testing/selftests/cachestat/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_cachestat
+tmpshmcstat
-- 
2.51.0


