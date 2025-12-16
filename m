Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8524DD5E374
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2F86B0089; Tue, 16 Dec 2025 09:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA766B008A; Tue, 16 Dec 2025 09:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00E76B008C; Tue, 16 Dec 2025 09:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C06956B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 598F013B619
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:44 +0000 (UTC)
X-FDA: 84225560328.08.403D79A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68B1AC000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895202; a=rsa-sha256;
	cv=none;
	b=X0st02q3dzE0wgoFIkreQVjI24sR5yv4VIJh2uB/U9G6RRM0GNcPby61H+nel9QOLWHTcc
	+oJ1M14qqWO0DnUZyhD4ZC3sbNh5BwYJc9DHLatzUss45oOa/1iBwFknnedhkONxbbRS/o
	MbfO3tsG6u9pHFpfJZe3wURxkAiZFds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=DD6ECNAocbxdJFtWgDEnu92Ce0P11/ttpVzOtTlvmBA=;
	b=pA1UB5mAZUUYHTUdsVC7Xt85w21fxQkeUrSChfYf7BpCPwX2eWcBJDiZnX/mh3F3NjmE71
	Yc49gI5KMv/9amy0nzC/gGb4ZidZ0WleZYWeJDWFKI2rD5mRQ5+7WubyHQuWjATwfVsalx
	HeJWpQCOYrVQdJXMTJ/GtnxQXPAvRKo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56658FEC;
	Tue, 16 Dec 2025 06:26:34 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3AF13F694;
	Tue, 16 Dec 2025 06:26:39 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH 0/4] Various mm kselftests improvements/fixes
Date: Tue, 16 Dec 2025 14:26:29 +0000
Message-ID: <20251216142633.2401447-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 68B1AC000A
X-Rspamd-Server: rspam10
X-Stat-Signature: xhigdr6omfo5798tbex3fcm1seuz9sse
X-HE-Tag: 1765895202-656584
X-HE-Meta: U2FsdGVkX1+H0fot+9BAC2bTMFvYBz+DvvCSd91kHFJo+2z2tICwNcRuWssTeOSz8Cp+EbuNtlgVyJtmmuvw/93NvPV0isfHKzvi/swj3JRUODvQvF3jKGnTFsHVN4r+gKPHQNx7V2wyXguXQ5MwL5M3P5jl4c8PGUS7FA40kmgAcFEGG9BBlnEKJr+tDLn81jA0KZYDn8+Y/ak1osavej6S16Myd5cAODGX3nfD//qSewpTX6lQunvx9D3yPpb+8Rx7Nztfxy9HisJ128nmNzqL2ANSPc8TCAYdYXZ9XpHB48sdHHfYi8pvGowweRQfNnjduhnbK2ukoh6NZKmFBZ94fvSy5nZkTwkdz/rlvmjqsH7n1hRhuupWtCR2UkHTY2intPe636FhVpmIVetWx+HZLFVZDi5oC6Zs5S/mPOGAhQmAsadqO2jWdZRl2Era8l9w8lapAU9sxBI4NB/SoRpDtyDGtFXu63TbJss5ebOPBmlJdllZiCgin0ExXKhqQc7+yTkqVzRFoddDNvnzmQq6ukunyjFcD6QNoOLOiQss+czOYPvfPVq2YhdWNxK64VnBZnI1FcNVcJbrLH+LMKGUb7qaURn7MeBqk6yTramzsOwQWMGYc/nqo37bHqV2gp1jAnr7493xLus/R2CU3k1QpubLfYX0qCqtSI3AFQ4yyYow2qeGXWj9oV53pRGWGXza0rlqc8TxT9eWIlw1bcq6xqSMwCabYNg95Ub7ZbRuWUH4BfpLvbR+J1l15a+LxyWgozKt2PMDDKZjQOfx4zV7n2YafjRctv8xwVTxvBoDU2edi722yQjjlqRImv+TPQ2npugBIFr4elvyY/Bqgnxb6WwWSYrRfk6mZm4WhE+d1W7jwiwrM5/0luYenINng8QfKpgtCOtyrKIA6sIqTsGmisq6qEtPWbSJ7X1R9StUIJxpbGqDALLfYXmNMqmRrO1xR9RdNV8jAoxOb5K
 urBMkmgM
 6yZoK2rINCV/o8b9MehbXY15Hmi78RHIud+qcU9d3XOffabVYtICdwRfz2cy/EVeGtjXA8pejofF8mB0jH9jvAh3/vR4q+dcKmmMpT/nso82Hpmae9vgJRglHKBqezAWv4YZUdGZJL1YWPjKXv4CrMPYtjbiWJjNM93znnmVrEFIVvTkEi2Qqc+KZq2H9ziOfvkdjr3F1FsUZVUaZawLs30RRuuwOsTwIGUBjQcFx+FvvklZ+zvwe4bSy2YoGQMX9fZ4m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few improvements/fixes for the mm kselftests:

- Patch 1-2 extend support for more build configurations: out-of-tree
  $KDIR, cross-compilation, etc.

- Patch 3-4 fix issues in the pagemap_ioctl tests, most importantly that
  it does not report failures: ./run_kselftests.sh would report OK
  even if some pagemap_ioctl tests fail. That's probably why the issue
  in patch 3 went unnoticed.

---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
---
Kevin Brodsky (4):
  selftests/mm: remove flaky header check
  selftests/mm: pass down full CC and CFLAGS to check_config.sh
  selftests/mm: fix faulting-in code in pagemap_ioctl test
  selftests/mm: fix exit code in pagemap_ioctl

 tools/testing/selftests/mm/Makefile        |  6 +-----
 tools/testing/selftests/mm/check_config.sh |  3 +--
 tools/testing/selftests/mm/pagemap_ioctl.c | 12 ++++++------
 3 files changed, 8 insertions(+), 13 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.2


