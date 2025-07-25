Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DD8C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFB96B008A; Fri, 25 Jul 2025 13:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0486B008C; Fri, 25 Jul 2025 13:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F4C6B0092; Fri, 25 Jul 2025 13:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAB2E6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:56:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C9941DC040
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:56:21 +0000 (UTC)
X-FDA: 83703541362.21.C27054E
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA0F840014
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:56:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bn3+8H3C;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753466179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EL+MWOnu6J0AeWzpNehXJxrYyQIB7n1NGQrL5l8W5j0=;
	b=mp6Sf9pso1NsBZmDCy0zNloDUZjE/xLHDpzMSuyvlq9jVvsjQRTZfBlDgbqun3Mz76sXJK
	xIlQxy1zFe2pKu3CGmVowbAEK8Qe5k1MoTjiarjqb630KAJ2c/4yeRFBYc1jYzdlE8zyU+
	0t9U7kCtGqF8Fe4McX5BaMp2sofRAf8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bn3+8H3C;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753466179; a=rsa-sha256;
	cv=none;
	b=2Ar3GPm+HfhVMyx6DwWzcQRsmYx4rFkAG8PEv0JQ18AaG/WLtXZHJmZi0bsyKNKGnq/i3f
	Ea5wPfErGSzrbXfR2ZS2cLS2EHTgHJ1mRyZMQVkrD2X73VplrtG43cWRfJmERuk0+/Heod
	VO46CnuId0KkYNka8DTeBS51xAUjHaE=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7183dae670dso22274677b3.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466179; x=1754070979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EL+MWOnu6J0AeWzpNehXJxrYyQIB7n1NGQrL5l8W5j0=;
        b=Bn3+8H3CZwO9t57Ukvt4OtQafObCm32Jc9SkU4HkJn/S9HlMxQDqrLhLpE8hIk1ug1
         dl2QuKczDpsv2AN/+XBxb7zx8LGgnwUzSKQrcluisGLPdfXT4/5uEYw1P5bE/FIJ+dUI
         5QE5se47SbgKAKncdLdgYdMsMDbi265Hc06q+oDnalTEb99cIiuG8RbaGkXTR2koaYe4
         YOCpxJbdeunO9PXRbdbK/ddoeObBf5OeKjhishHddoB7RnYHRdY0ZDd4wJ5VYw4Wsm+Q
         IaV6iZ3x5cZ93NP7d4wq78AQ5vP0C9jn/Ss+YnZ8L9OCtrr6W7XFxdZL2GaOpq2DpWSg
         Po6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466179; x=1754070979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EL+MWOnu6J0AeWzpNehXJxrYyQIB7n1NGQrL5l8W5j0=;
        b=pS6F0jP5nLXDx2/WH9pGdTQ7bOLmGdyHv4eFuitA7Xw5feR+3Thw1aY7Eqp+K3uMFl
         38UEszEAlT4O1HWnHLSD41jT2Fjt/MuOEkcFcnN8kH3mKF7V3qp9qxxrhs+lBy2O4/FR
         Q9AkRaaVkQVo8mNGnmR3akMpmg1Li3h25GMNjqvyvi/zJO3A6zX+TRzg15+Z+0TgGfgJ
         EnC4U1cFvlDSB5FOIthEKZvWlzIOqK3hJN4t5QAsBo5S7rloDe35IJFQqHadGECVmgGG
         aa+3h4Blt32OYGT/SSFw4RLKSyP2upIufFFgsOdtpD9m6QlBPcqfsuALxCL42E34qICs
         r2yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuRY7EHvue9YI2IX9t5EEWJqCo108czktaYygQBe+/lZZUW0hLI6C0TbGSeFcKG/yXOzM5UPkWmA==@kvack.org
X-Gm-Message-State: AOJu0YwGbANHQSrtY6dUvNBR8XdWLheeWU5bQ2ghm6xpz/0+zRHjb0ib
	UD9ASmuHizPodCtVBBLlFqnDlG2JDU6yv2ZQR2xveXZzQJNz5FWbyi5/
X-Gm-Gg: ASbGncvbij8fyFAxfaj855f8yR0uGeKfuQ5fmgEgWUSvbXFh2YJD8esbDUbzMcLmu7n
	lau9ZLkRsLTPQpdkAg314q1SNkR38VlVXkdCHiKMh8GABurrNsBIxs4DaRrcOUMTjcAiVYo8tl8
	nXtgLy8xeagsNPnuZMpZ89QEsHdQ+TFf8KDjtpp+Rbh60BgcNZ5cz8dO/VXHPZZ9dDsZvH+rFSt
	jTXLpfq3+VsPsmspdvuqn0U7ZiPB7e2Ndb1hMR3IQD+ytGdNQxiTJKRxUmBdKcLM0ik2PkhKrbv
	TFIyBG30KqT30tHKqfZAN8WR1UBAoXuig5FT3dS9JLv7Hv94xwu/gb+zRhPm1eX/Nx5xbkFbvU6
	bsD4nlaarcgNnasyFmRVeWFDxLVcdiPhY
X-Google-Smtp-Source: AGHT+IEoRwVXsNZPqWUO+bMb1H+ndTLEcE9IUQvqFvRrxdUDdtniK0RMG5+DlEeoV2qd/i/01NmnuQ==
X-Received: by 2002:a05:690c:a4da:20b0:719:4cff:16db with SMTP id 00721157ae682-719e342c9f9mr22522357b3.25.1753466178462;
        Fri, 25 Jul 2025 10:56:18 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f23ad29esm774787b3.50.2025.07.25.10.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:56:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH] MAINTAINERS: Add missing headers to mempory policy & migration section
Date: Fri, 25 Jul 2025 10:56:15 -0700
Message-ID: <20250725175616.2397031-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA0F840014
X-Rspamd-Server: rspam06
X-Stat-Signature: dshxfqf8gtcfq3m7merw6wgp9qh8c4ha
X-HE-Tag: 1753466179-227954
X-HE-Meta: U2FsdGVkX19Onui39ro0yafCKt1TnN98Qb5vSHq9FS8mIePKhsJss1gAghjimLjhGm20EQT3wVw2w2YkJLx6qC7dnFl8PszJ4Ddz1SmuiFxUPN+WakVliVaOpvWoaRgDeL1aZwVMPIgCpfLFlAdfpQwyY1NoE6JCz2Tj/pzK0AIniiTnod4XanT/MkdcG1M1k3IetAIiRqLfvitH17lmThwu5g1kw0Lps9HwQma/cKQcPqVB4Vn/WDRuMZhpl2Es7lBsrCCgTazFzRLLLXOEzm6OEdqge8N8vQGT/yS5ZG2BkA/MkfhK86ITgp1unW8eTjcQIIdx1N7rwS1F8gPna0bOWNC4/76Cajv6uAkc9AleBd4WUS/bQ3eYrPih5nUCgkmmPx8OIIGM2YuLqtIGFDumXK3DN6AIrjUqay6SMQfBrDf+YVXdFPuMUDluJf7pKLp9vFpa78cCI3ldyX3mEkmmz0hwIOIKadKbNWmS5wnTSPG8dxw2YFPNCPFiblpm0h8Voy08hUHk3bSwGXNUo2fqebU2c1EKlPfepTH693EXfz17pe//4EfuW4+OEPKbOPX+lCBHoopLqUHXlXcjyWu9MJ5o+eE+eRwp3WzKfEXLrIGZc0rBiOCBzkbHT3J/2Bu7U0SdNHKfOc1OxWNUNNY5AFRg4UghkFWICMS1Lbmd+t8RECLK0PWOjRN5kRR5o0w9jcM/IPK3Ge04R3KX5R7cn8gzLqpwAE5a7DVHrd8XaFaZt/KceVMOFi9pZOiXy+bb7KH5D+gkN4HP5f5gGT6U03dM81nx8cykfFpXtAT8ALKJnbM2rAx4uw7Xn1N9CeTIBb2hiKBSQf66GSpmS4oezVPiSDpJDFWG89139E9sZJpWlo3asBYpXSw3rtSW2+XAw7P+3acFcrq9g8EL00UiOASDBltWx7PKKwUvbBOXNj2Y8RW2X+vA9ALb6wV5gc1B3TH0Bz5iCNc0uMP
 kKsib8cz
 hNxFUGqGjTNXFyffpJq4i07ZUJQwMxE0FpSbZxzD6LSycQBYNtU3w3khNZDM8+J3DxNMb/ikWmYW/45BFhkFG+zTDrhx2zsGg5KY2WXFw9nZ32+h8vELQNqPuNVbo+T+BOg1eAgg2HSGDdzjrIkMDmtgttkPaI/vKRisRtPnDJo0PCA7ahf7IxIUf9qlQrTBGH+EeBfkIDjPkPzQTOBBLYqTwqjQKzuXhr+6JLaGbb+2JlNj/pIl67YwwZbj1GJV42zBg1MYGStMHobKS/rSMi+ElHswIbAaIYttU5yl/S3eLCAzWOiGhYJeS1U3LjuPHQ0TNKUYjg6ZGsF8Dk+lDI1d7XZrW9t6uqcOmmk8pb67rqSMCleHUNlP9qbytJ1kTPwV8IpZqkNxxwN67PH7ncEZc3MqlsBuR5kbex2NyWFZJdCKlOI8/iRqyGDXsVCjwrlhOe2T9C7GMiuPzOS9ec6jrhAm1GOs+D6dk3a4bbfju2RR9TPXbVzqPX7Zo+8zbVVm63ZzVcS6Mm08wFxLPr75zbRyr97FyttVpg4ICupzHSdVaySfadhFnaH3S6Am7Tae9/KoIVZRPXin76eGV+Z/Z3Kmrjc0GrwS38o/UvmWUvus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two files currently do not belong to any section.
The memory policy & migration section seems to be a good home for them!

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a8bebd0886df..dec8db8b5cc7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15838,7 +15838,9 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
 F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c

base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd
-- 
2.47.3

