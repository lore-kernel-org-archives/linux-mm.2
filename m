Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF81C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB486B00BC; Mon,  4 Aug 2025 11:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892056B00BD; Mon,  4 Aug 2025 11:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C866B00BE; Mon,  4 Aug 2025 11:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFD46B00BC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE9991A0182
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:44 +0000 (UTC)
X-FDA: 83739495168.15.E4A4101
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09EC240007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D1wblxqI;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7FGysSwc9ir6e18/+ECYekeynrX3D9ugFjSYDa8j38=;
	b=wl0G4UMzPk9aMSpsDBhoeQZo1PRD5V4Tq0vPKg29XNp6sjMPQARVXlJqWQCghbabiHMSXc
	PXUJITT2S+Gg8rjGVxVQ4yj3ZZTrQNODgXnXo17ngv5ceSY3UpXXGoCKcQTwR+1vwzFecv
	CoPELH6+WkCCRA6TZJs9vNf/ayMkaLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322223; a=rsa-sha256;
	cv=none;
	b=jkX5czUtHAQYlli+F0qPW5cN5AYgYwP0gz7JHgC1x6Ybf4soZxThHz6ldrAx6ly6gLFZEL
	11Z2doEpYLJKc8k/MzgTxS/LDp4+EcgNVUrPtJSjU7wEfC+jdQf5hgtQJcOAtpIMLZyN1k
	RADKzWsY7YsxiRItYVll4RyQcDrGoWc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D1wblxqI;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7dd8773f9d9so345870585a.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322222; x=1754927022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7FGysSwc9ir6e18/+ECYekeynrX3D9ugFjSYDa8j38=;
        b=D1wblxqI8QUigXLITZmclg2HKcyG58m8aDE448OnsMtaSV26x56yaM6emyXD98tlaa
         kIlpAPYAgHJ20optiHgMHz+YnKHxBFLAoHwtcArdHA/8668lPDzHaB7lwFDn1/skWlNM
         ZZEK7lof2Ud3pPDTxBKlBrddxWI+OndWjKOFdAnvwOSt6lWkt86n7lRgymHF5JGfUdN5
         PrdqIbHuilADDtPfbc8PKYvoWik9ioN/lv9lwXGHS5P9Nai2pA0kHYFLfT4r8tLZU2uC
         dj5gvV6XNly5DDOBYBajyPECRYMbJ9ylO7e7XaqxtZ4IugguqfNKdEViknpVUMzZnBg8
         z0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322222; x=1754927022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7FGysSwc9ir6e18/+ECYekeynrX3D9ugFjSYDa8j38=;
        b=ItoqxvAG4pm37e6JOmW/woIDDPxUaqMAfjioTQ45HULGQlOC9EtZ0z8J16ilsqSoG6
         gAalq5shAPRCBwyn7lgczC7weleB5iHUhf/bqR6Iop5c8bKHfvh/+HEKd6qCKRmRdjbr
         ONPBI93Gm9oeKbjkgIJKm2aD5GCWurX7HWAisNl3nlGlpZwWmMfT7IojEroIgLQBnRKZ
         mLwEU5VLXMJIJ6kjaj9RvUthDWdO6bzgPjPV7cdWQYSweHAUjoi+3f8LzQ4OuV31TL4Q
         aWzBtVcYg8Iryd0UWUD0q7X/TI+cvzqWeKPZA07QS6bYVuJR6cEriabc8PcpW9nC+H+s
         RQIg==
X-Forwarded-Encrypted: i=1; AJvYcCXqajBC8IvhKghYLcCVOvGaM0dOCqraRIZUiyNOJZOE6ZWsqicZrVHp0ur3bm5C1UZTKGpxFiPqCQ==@kvack.org
X-Gm-Message-State: AOJu0Yym6B/paI4FducX0XW9S/Lmb2GQtMxruFgVARvfrvlvzteGhHFP
	3X6mMjCoghu4T69Jjvm9SlKkkxdzm2u8uRxNqXfaZXGJQF6AfHu/tJsv
X-Gm-Gg: ASbGncsUYtAX2fDxZSUMzU/IAhkVDtSajELqS3bIRu9ZDI5CUNapp1wLdSU4Pd+Xkc4
	BXHKIwi9uiBs1ifkWCxjov+Xv0n+rS2ZGtPfAfm7z393S4Ai+sqYyfSdbvBFSPeSJjg8zRn/ox0
	DA06ETZfz41vgTcxKU0g8LCLIcv6QGVgAwgBIDLeSx5bCFOkCE7csaw1OZNx01jmflKRNa6aZQ1
	CXsJxwjUjpIY07y5P+NPSlkUQAGRCacIV9oe/zWKGA+ITlnzcEkNFFDdF+rXeNfnJAV9Z8M3QIg
	z4+NtbA/HT5/9InOOMqJ9xYyNOGDt+14k+1YAyz4Y25xoJK8iBLsHjrefenLzrPHdDO35s+uX39
	cKfubUOshYy+livP/SKs=
X-Google-Smtp-Source: AGHT+IGS07Gw/uqMyBQHFvHilTAJPxp7B447DJt/tc+a5i1DvNlJq4ZtECfwx07goEsa9zjexjCclA==
X-Received: by 2002:a05:620a:39d:b0:7e6:30ad:be32 with SMTP id af79cd13be357-7e696268883mr1447844185a.5.1754322221625;
        Mon, 04 Aug 2025 08:43:41 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f742e7asm559131385a.71.2025.08.04.08.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:40 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 4/6] docs: transhuge: document process level THP controls
Date: Mon,  4 Aug 2025 16:40:47 +0100
Message-ID: <20250804154317.1648084-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09EC240007
X-Stat-Signature: bsk145am54a5r33xy57idp7ujwzwho95
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754322222-313930
X-HE-Meta: U2FsdGVkX1+Tdx8sm2oyeXrAULJ4/FQ78TuVWqpnd5GJo9joMprFqu4qpm64W9BdI3bwx8z07I63JP0U5m6Jbc6xI+Xd/Xcon6FE2N4FhNclOi9Dq6EARJCUeMO85Na7uzYqc3h5j3uWM0YvEXUAZfh0hXt/UUzPbB4HWsExCsB29S2GC63Yb3ACedaSh5ikv7lCgG7H9rVTYpKffBpZewx6k78iqYO+Vi2MSHwugUCEjys8VITOBugatbsWRKGQvSGYG4n4Mp/xMgS3mMJFaArw1GAUcoXdEIoCQQPnv3HvU76FrsVSYA7qVr6muFW3HUU0FyPLgHHBpb5ea+rQYRCGbqNZqQ9Sxv/fiVZ5qHHbgNzco0PGEN89PgUy8FcnU9zSs/TW7zgYyIXB2dVlAa+2RKy9cfGBJtKypn+jH7or4xFYM56PuxFtUGVAdq989TGDawGVbE2ttvU+vaqgtvhrsZkmgoP7pKd0jFql1FHsc4WGX5rqrjLvlAqDfpwGwwInGN7/mrYOwUe97VgPtyo6AZ/slV8tPR5u0NSyNcu0h/d5PzLoPQETFbjSmse2sS/Tq2lRtZtAYpkClNfyGHT3x81n284neXsmiCGTwWbf8d285LB7BZx0vWW/h2u1kC6MvegW2gEniu5Iyjie2AFBtnRXoxl23jK4PSC9A49QIQm4ajxoP0zcy+qjRC2E356Dz4ZY46PR8CJ4jD9E3XpOaB7W+iLSOBoUpDW0oyp1jLfNtP1Jc2L/n4Dy48Ci1pc/k0M3ATiRyf8z4jvD5o97znsUW920uh6xufbF+nQ56RTvoB19O6gFqztJIhVr9zBlDGW8xeu+7NoqNPm97rEThseqHxmMoeYQ6wheO3MDmwFEf6c6SQi4/tEy1WktC1/3Elvpbt67KnjhHmq915KcaS4KhM5Xo4akTC3e+6JZShY+O63LinEQYHH29PgM5V8MwApKjQqpckb72cq
 tjDmYw54
 OVzVw6Jg4vxiiLbL2yfJm4d/B6ai3fOPU2+aEhnRVRfLBUZUro/BgfXXR0OQmE5Rbg/dGcw6Uru9eieRMUoe0la/TMNdTyP4sp/zxmppsS1TH7Up7EsPjHPxZdvezI8l5qZCoI6utyPyKx3Xcf1z1+XPKqm/bGjkJkJX9Dcf0J1EmA7tDMtzP7uDvXTtDBDxNk0/vpjikySN37hMLIWe7Gvz8OrX+O5+tV36+I4WhEhmIjszNWej4ZwYq3vHt7f2BcIgeVAImGQ+slgMJvNdXeJtpx7+UHrmjWut6fZ7qlV6OXRIKh0bqBJDut9RZ7ZX0jAYLnjw8Ngubxu8lkEWVylNMtW8xWnw7d6Aw0vwHYchfs1VmMOVd0NH9W6E7eZ+euRsff2H6f6nnyxebpyl9IM2EBqYtAIvR1x8lA22R+gxpo71+93Zz79jKBNRpUeBu7Q09k8Pvfx6q78wPv5z2LQCVfeu/DzmwZt1anKF94fZjDzdl5Sr4taV68T2r3mU47VAdjcgMgRXlVP7FdP+Cg7Tgr7IGwHvI2U+4D7qvJ7fOym5ocbLFYFi7CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
flag for the PR_SET_THP_DISABLE prctl call.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 370fba113460..a36a04394ff5 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -225,6 +225,44 @@ to "always" or "madvise"), and it'll be automatically shutdown when
 PMD-sized THP is disabled (when both the per-size anon control and the
 top-level control are "never")
 
+process THP controls
+--------------------
+
+A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
+and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. These calls support the
+following arguments::
+
+	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
+		This will set the MMF_DISABLE_THP_COMPLETELY mm flag which will
+		result in no THPs being faulted in or collapsed, irrespective
+		of global THP controls. This flag and hence the behaviour is
+		inherited across fork(2) and execve(2).
+
+	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
+		This will set the MMF_DISABLE_THP_EXCEPT_ADVISED mm flag which
+		will result in THPs being faulted in or collapsed only for
+		the following cases:
+		- Global THP controls are set to "always" or "madvise" and
+		  the process has madvised the region with either MADV_HUGEPAGE
+		  or MADV_COLLAPSE.
+		- Global THP controls is set to "never" and the process has
+		  madvised the region with MADV_COLLAPSE.
+		This flag and hence the behaviour is inherited across fork(2)
+		and execve(2).
+
+	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
+		This will clear the MMF_DISABLE_THP_COMPLETELY and
+		MMF_DISABLE_THP_EXCEPT_ADVISED mm flags. The process will
+		behave according to the global THP controls. This behaviour
+		will be inherited across fork(2) and execve(2).
+
+	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
+		This will return the THP disable mm flag status of the process
+		that was set by prctl(PR_SET_THP_DISABLE, ...). i.e.
+		- 1 if MMF_DISABLE_THP_COMPLETELY flag is set
+		- 3 if MMF_DISABLE_THP_EXCEPT_ADVISED flag is set
+		- 0 otherwise.
+
 Khugepaged controls
 -------------------
 
-- 
2.47.3


