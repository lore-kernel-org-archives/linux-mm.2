Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312E2CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D288E003D; Mon,  3 Nov 2025 03:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDE88E002A; Mon,  3 Nov 2025 03:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B688E003D; Mon,  3 Nov 2025 03:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0AC8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:22:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFDD25C410
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:34 +0000 (UTC)
X-FDA: 84068604228.09.A854E87
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19C164000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+m2W0nv;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nj/c1BzjIxpTO3kgh7+pFVSsAoolfSYT6E1Rg5uvcLQ=;
	b=1eMpAFEER3LMU9DRq6yzXELQZjZqtVD88fPp8o0k9TY2sjv6bYXQjleOopWqrObFVY0R2u
	OTMbHOhlpwdUIbziMGCml0uW8P4cnykExWTfw3PcBdhxKDIZQRMleQX5zgwr7E4LIWplCG
	MIu4ESVsgPC4uZwg3x7HAD8XuBUGtKs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+m2W0nv;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158153; a=rsa-sha256;
	cv=none;
	b=eaCY0xIy9Il7o9NB4m3ckXmXmNDmHJBGvZeOxq44YdhPBubn1LPyxUt+5KvvdnW53M5RSg
	UbnA9YJRjyt6m1iTyj6M0t35pRddyh0ZqExSDCLbwCElca41+LRcAEsxXx7ilxcXFc/IHZ
	He1GqYFaOyYqrx9o9KRCBHLfludURhk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762158150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nj/c1BzjIxpTO3kgh7+pFVSsAoolfSYT6E1Rg5uvcLQ=;
	b=N+m2W0nvJkFqajogTrfNlWsOh+oMmLYJgIwnKymVk7YFrAfFKO+zhlFnS8Knje4fEW7rMq
	3hchLSWbyt2lZEhGCbtodlWvB1c9rL9Ia5gABeWYUKgJoF/Y1T5Ti/zRmvSpjepyipiD5q
	S3NNljJ5IguKYIOCBvMTi0epqSjcafY=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Mon,  3 Nov 2025 16:22:07 +0800
Message-ID: <cover.1762156954.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19C164000A
X-Stat-Signature: h8ymcdtbigh981wbep85i3jf3k7ze1rt
X-Rspam-User: 
X-HE-Tag: 1762158152-691671
X-HE-Meta: U2FsdGVkX18TA6W5kXrMPcA0Il2QmG0poikzkcSqY1FZ6XfaIwUS0xFOqo0RzHkP1ZnaMdSFQcSMZMgP63HqVbjbDNQTKKpAhMxAPmrq0oSuPsarGrtuX2c2/WydPYdshXrDvdWKM3fB0SN6at5TRP4fE7R4zJS5slP1f3JuMR8BX6mL5momfxoEOPb/h7sv9qUQkz15y/HScTEZleobnhFFhdBI7/C4drMs/7MPOGE+jp4VJoR6B3dL0OtRVxgQPY2n36WSjEaGJuHNVKoKF1+do7a4HP4U7SJUOQpt7gscxYtP8BX355iAi7E7AL0SBUw1NxowGIWMU1glRMHLy3MI6W2vG3yEyVNZh+e4vKkIHrQF5F0t4gp05R+dfYOkXBFhlWHwQYHnlyWII6lWy9ZpLZ81BfvZb2DVkV8gND/lfGFg72I6jbcGawwI1Ax+CydsQHGkSFlZRmfnFL/c86LXuTb7UNMiFuE6VJJiMIGwyaQAxCjluNvLlILJjX+8nCAaWSTPd6jK2da2dV3BP0LMfP/yxTOSKHUVynSnIvB4byVfWUoSZKJHY4JBWNTGeQ839gUuEMh4g92uVERSjcaXN6NKV3/3V7xfr5OG4AyaS3IxE7QYfY2snx95BayUPPNSr72SndSWlU+MXzYx/Wc418NqCsrhF+AOOwEjvXNWMEvmgcxrxBau37T3nB79fM/OO1DxES4D9KBWDLQWi8Us7asD4cBZugcusseisTgimgA57nzg4Cbj7sgoVeN7zWQ2XVGiaEJHXVIEYrdDpWS7Fqu1I6BRN9SPBukgIu5rIZz75gIMlos2Veu5BIxLESB6sXq9bV0sBVMgcMarm9qbUdYYwhoaMeUYMchciDyUbQ4KQKneXZdSKNPmaOD74tJPbpwLX5cIg/+3rUrwsLx9Cb7o7OaG4dGFY4gzuHr4OoTs5mscxqJx6MOaq80A7zSDLFiVBwKBFM8NeeM
 C7XPDdYl
 JK8dYgkBHFRZ9UYxbKLaxRHO2VhM54TmQELDhlSLOkrOmViBYiNLt157pbYxGFA8ayjUoxIY3i3l14AaGuuh2PB2SdR9a1p2e4yuIaD8gEkSalw+V+brr0ZGJZkOopZIEsTLMXhB7hqUTy+1OvUJal2EIKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The hugetlb.c file has grown significantly and become difficult to
maintain. This patch series extracts the sysfs and sysctl interface
code into separate dedicated files to improve code organization.

The refactoring includes:
- Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
- Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c

No functional changes are introduced in this series. The code is moved
as-is, with only minor formatting adjustments for code style
consistency. This should make future maintenance and enhancements to
the hugetlb subsystem easier.

Testing: The patch series has been compile-tested and maintains the
same functionality as the original code.

Geliang Tang (1):
  mm/hugetlb: extract sysfs into hugetlb_sysfs.c

Hui Zhu (1):
  mm/hugetlb: extract sysctl into hugetlb_sysctl.c

 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 852 +-----------------------------------------
 mm/hugetlb_internal.h | 116 ++++++
 mm/hugetlb_sysctl.c   | 136 +++++++
 mm/hugetlb_sysfs.c    | 632 +++++++++++++++++++++++++++++++
 5 files changed, 894 insertions(+), 844 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

-- 
2.43.0


