Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8FAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E038E00F1; Tue, 12 Aug 2025 04:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15CE8E00E4; Tue, 12 Aug 2025 04:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B2E8E00F1; Tue, 12 Aug 2025 04:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFB178E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:12:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62E6016020F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:12:51 +0000 (UTC)
X-FDA: 83767389342.16.ADA5343
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 608451C0005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:12:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="WLFqyLP/";
	spf=pass (imf20.hostedemail.com: domain of alexghiti@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexghiti@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754986369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yw0gy+knuGeGzY6jivnMfN7pV1rj29Xt61Zw/czzFhY=;
	b=3QH+ZRLIMDOGP0msEuWIp2/eKzwMlXnbcFDFjzBYy1S2hT4eRuau5/5CMP1lKEaijztzrO
	SdWxgDZtIbC30OsNI1lIYdMju6fzSco/+rOJ5U4Zo40ObXFd4P5czwrT2Yi5Su5B0ZXhwr
	UDA2gdntVMlUexOYKMDBG/DnJYhjRB4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="WLFqyLP/";
	spf=pass (imf20.hostedemail.com: domain of alexghiti@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexghiti@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754986369; a=rsa-sha256;
	cv=none;
	b=6JLvtJCrjkI2yQxK/x5bYJDTbvFjp6BAgZ47nr16IpvKT7U3/bl6ppR7dMnq1vZXm3rZFQ
	R0w3KJBAmCIZ9TnIc/huqQAJnlOcYg0xfQWYGxOBpQXAuiavLR0Y5WyZ6QB/XwsMB7qhoH
	EfG9vXY+MQvVVNPoYq5KfUpAYAryMMw=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76be8e4b59aso4421300b3a.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754986368; x=1755591168; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yw0gy+knuGeGzY6jivnMfN7pV1rj29Xt61Zw/czzFhY=;
        b=WLFqyLP/gq6E8qjSuM5ccHT0Cu1nvPlyYiEwCIte9IyY1lFFKRfqkHqOrlGyeUIEh0
         XoVX+kc9dLzAVZD1tLKpO8Dq1FqE6UZOBu2VQoocPuWJNV5A3Ijy0nAz/Fndb9UlC6OI
         ot7KvBI15zuhZ//twIuIkCzoqB0UOeHH95dhTrIIOqyXRSO6bqnQmDXzUgAnqkHVG/vi
         GI6MfEF48GmFmc2JSHrxGRIco2sx0wOzt0o3DPVHKxaNt3WFq8YSAji4YZ+RyQSE/CDb
         0w6fYXZlq3oesxM7vL5YLQU6z5V/xY7aYsobNXlcjZwLHh37Fp9elr8ebs7ZGIubenaq
         6CeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754986368; x=1755591168;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yw0gy+knuGeGzY6jivnMfN7pV1rj29Xt61Zw/czzFhY=;
        b=qvy3za+CgEOwEF8K+gcVY93kuev7wDuSZdM46vRszOP6BgDeyCLvUGJvXOYMu0TS+5
         EAa07YpAsiGk1Vcct7Hb2J86k9/WnHpLmewcmTowhR/I95TRaiQdhDFnMvqcMm8MfL2u
         S26eroxhqsmki/0OQYfvDv+lmqnCdRY3uMz1krgfTCsm+PBR69dwRSBRV1MxJMwbqxBX
         11ysv8/rkofRU9D8WTpUe3IcwiWQYrh4kPtddWYS3U/xirYRz1fb3CIrqy8G8gnE7Ea1
         F5C8y03JyDhAIhHP+K5zmaiwRHgyIHeNoE8o+nzrjD9ClZk2d57pQhr5RVrP6HPzEQ3a
         vUvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQJ1ZSnyTlz/ft23P4GQCnONYOOybp8ptfdLTe1wUbWv7r7HyY329mnrcsqt6+O+43Qb0A230g/w==@kvack.org
X-Gm-Message-State: AOJu0Ywd/ovIA/b1R7KeF3HpJkAi2905wm9L7vfFHvN7uz7IZa+in/TB
	99191DTj4eOoyILfNjYlIIWFjBWCJISRT8eAvkEu7iM9Gbg51CgwIhYdE2wm2Zo6V3sCgdz3vV7
	/4GVJ+L0=
X-Gm-Gg: ASbGncuPLhmkIo25wGwlCDd+FBSNVMQ1wtptf1KgY3u7ucxCIkVTOXTdI7J1V42/VeV
	9VuDt9oe6QjnymX1uLSqR54Y4oZJrYaLi4X8NtrRCRMDGbjREvpMlmGhauUyqnyMaRLYmA4LKwj
	OnV4F/mIWQ+ullaRVLtd/8o6TKlAN/1EIkbAU49Yn0n+l17cD5P+5YxLdJimEhbMYcRSMEMVBII
	Di16Uz+EdHlpgNKZzgw3DMm337IuHkgCGuApbtmWVUZd9my1m0j0nk9tJIPZ8eAGlwiMkntfPqZ
	NB8SIwf6KSmYoLKkvoBbRyhfU2iDYGbfXjUBCEISDvzUUf3WGsjtV9KcOLVQv7ph8kGk3LPztxX
	xypTatBPSqJIG6hs0w28Ytdxhl7mxFxiXBL8Z40EazriygLRKIolrvczKntOQNTixylsAwA==
X-Google-Smtp-Source: AGHT+IGv0knKdRcpuo+yhVFvI7xkp6TkQ4XGBRBCTHxnRsgbNXwPcNcWPjfrvDLzGLuhSytlCrPZuQ==
X-Received: by 2002:a17:903:247:b0:240:3c0e:e8c3 with SMTP id d9443c01a7336-242c228e6femr208574645ad.51.1754986368009;
        Tue, 12 Aug 2025 01:12:48 -0700 (PDT)
Received: from alexghiti.eu.rivosinc.com (alexghiti.eu.rivosinc.com. [141.95.202.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0e83esm291171955ad.49.2025.08.12.01.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:12:47 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Date: Tue, 12 Aug 2025 08:12:11 +0000
Subject: [PATCH] selftests/damon: fix damon selftests by installing
 _common.sh
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAFr3mmgC/x3L4QpAMBSG4VvR+W3FlsitSDrZN04x2iK13Lvl5
 9PbmygiCCL1RaKAW6IcPqMuC5pX9guU2GzSlW6qrtaKNzzKyYM47ewv3hTDGri2sbYzlL8z4O9
 5G8b3/QDygZf4YwAAAA==
X-Change-ID: 20250812-alex-fixes_manual-aed3ef75dd83
To: SeongJae Park <sj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Enze Li <lienze@kylinos.cn>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Alexandre Ghiti <alexghiti@rivosinc.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1133;
 i=alexghiti@rivosinc.com; h=from:subject:message-id;
 bh=CygRsQzHeViey1sMjJDwpFXY4aVKiZK+tOw7A+FX4l8=;
 b=owGbwMvMwCGWYr9pz6TW912Mp9WSGDJmfS9tPHdv2e/gSPnDbX98/P6y8smEhomFZkvN8NSNf
 JzmepKxo5SFQYyDQVZMkUXBPKGrxf5s/ew/l97DzGFlAhnCwMUpABMx2c7IcKJKMfDZyu7SW6eu
 i6sb2R6bxmCePlXJaktytu0G9uKKlYwM129NC3i4x4knS9vwc62dnPXFhi07dT7cYTz3Q6epca8
 aIwA=
X-Developer-Key: i=alexghiti@rivosinc.com; a=openpgp;
 fpr=DC049C97114ED82152FE79A783E4BA75438E93E3
X-Rspamd-Queue-Id: 608451C0005
X-Rspam-User: 
X-Stat-Signature: yqi331fbk4dnq7y9u1o71pekect4g8ob
X-Rspamd-Server: rspam09
X-HE-Tag: 1754986369-904250
X-HE-Meta: U2FsdGVkX1/SZwvz7Eaxw3U/Yb5KhVZJ/PGepMvNG0hClRZcECZDmJs/Uc2lzA/koTjsko0S1EDfCI3Icb76E7F0D3yZyUBCJOycali7Blq89uDCIW+EVcGePcGDwS0jM77tBK24mnTALmjWowAWSViy9ROnFEwz2g/A/Hd3LnrRo/AN9sMeg5s0gddVfoaBhTINos5Oq6nfpk2C7CmpOdPxXQspmYs7teSUpqcuRdFqR8TARlSLW7VI7vgudcBvqeJL2iOKsgIbQrdXy1waz1tdSmecudVdBqGpCi1A+ehB/lalIJ4N+b4wBdteosGaGqafVlrtrRQkYMzWHo3crVq2ZtFhRQAWJ2qQSdsENRI16noScKs2Fpn2FYPdTnnuMAMxbqf19YDxa5g6/iva4tYKEzGAGp2krybIvOVSFYWo4buNWZHTfHJ4wrJY1XDmfbWgORVn1W/QN+eeQFpR6CH4Fq036gw0oLasr7AqbxOyCZQDRJSzKu4wBbWwzE1Rp5swBtEwI+xotZjv/stjOvWs6DUPjOOwGm8siTUg1CGNpeJ5vhSmSU40qYaxW8zrd3rZIxqPyGxG3kfjx3i40NtdwPBaDWHb1jpksBI+C9b42cAMFoKsaC6gkl0Y3JDsYOF9fTa+D/nzarPMnAF7ZTziVQfLs5PNUcf4Djit6XqUdm+NbXWmBXdgHP1iYlDcYNjZpldu58Fbk3/6tCf7jwu0hY1Ek5+5wC3br+VVLJ3+uJfgY7xIpMePX0Tj68D+ftTYilcydtkA+b+1ZLLvUra0vFsET6JQ8aWDEJuVRNflfa4a3uZmVvkUneWNUZz1mUjVrIA8Rg6Mw2K4WieFc4YxpFEpAvJYYKiBK0+sKMEV8/a1QzM4cpCvZLRZbmLRDs53Uqd7hVr5Z3dRSqu7j2sASgMYVcLoOAzCLNJ9zsytbp0VcYKoeacVhebJKTUUhmfr4W9IMMbwkXrqJl1
 kpBSOh6D
 LKjtZALy2doqzsYV+Yry99I/08983YePmyOA3TroFUB58qB1roDk+m5bIcyw6vm1LDEDqXEP2CUnP5QsM5N18fSoW+mZr/WVqsubp7GAegIISYX+GefG/ey04rGoZjkFtTIOYaaoz/ldmGit3YYItkx1GQ6G2U3lSFXR2PbSFrJcwNvi3qEkxQS6MQ0EpEmRZ45a8igxDs2ENP4CYARlW9qX1wD5OhyMBWeHiNs2LRL8yCIy+ZD6cu4C382xb+2iA6JzFQ3oecOb2P43YICpvbIZpD1+BS9/iBhPRPdvpR2vjKbQb1AcE1S3fNgr6vW9BIE5tmvOvkeH9VDpr4nUvrdFItGTiiFMtG9OAkL0yaCHOFvFShPa5kTUdrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

_common.sh was recently introduced but is not installed and then
triggers an error when trying to run the damon selftests:

selftests: damon: sysfs.sh
./sysfs.sh: line 4: _common.sh: No such file or directory

Install this file to avoid this error.

Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host shared function")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 tools/testing/selftests/damon/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 5b230deb19e8ee6cee56eb8f18c35e12f331e8b7..ddc69e8bde2905ff1c461a08f2ad008e6b28ac87 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -4,6 +4,7 @@
 TEST_GEN_FILES += access_memory access_memory_even
 
 TEST_FILES = _damon_sysfs.py
+TEST_FILES += _common.sh
 
 # functionality tests
 TEST_PROGS += sysfs.sh

---
base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d
change-id: 20250812-alex-fixes_manual-aed3ef75dd83

Best regards,
-- 
Alexandre Ghiti <alexghiti@rivosinc.com>


