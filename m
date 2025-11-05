Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E5A1CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9028E000A; Tue,  4 Nov 2025 21:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1E98E0002; Tue,  4 Nov 2025 21:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDB98E000A; Tue,  4 Nov 2025 21:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7191E8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:43:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28BB055EAC
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:43:04 +0000 (UTC)
X-FDA: 84075006288.26.C6789EB
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6EA5AC000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:43:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e5TgTHzA;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q296D2qx12EQHPobfdWeDRQ2wlvOioDM4RhRYWBCXbQ=;
	b=rwHdHUj8vi9onAEUfZh79stm9US/PHYRV5k77PxpgOD9L5g3d+NAllGsudcaCBwGR6DFfh
	fJRZu4BurlHKSZNZVtR9UbOPAhoT69knU6m/IyKQ/9lC25pJgUYve/k96LAkNeDVjfxQhj
	Bojk160TuvZoxuGlaIvBECBZR8NZjbY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e5TgTHzA;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310582; a=rsa-sha256;
	cv=none;
	b=GWHNSzOLHwZ9FNMoUdbrRdB1Vl2Odrn3OYK9hGy318/cbI1y7I5sXvfJnb+Oh4oQmgWRz2
	wHUfyRZVSqU9tuMewagGW61Wsd3Lrx6HtjkapY24z2RBrzDzdXyzVZKVZFly4Df9n9jVU3
	dHr09IC44N2R7ZSUKl5vc3uhiAt/wvQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762310580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q296D2qx12EQHPobfdWeDRQ2wlvOioDM4RhRYWBCXbQ=;
	b=e5TgTHzADd7kbEG7v6Ro73cCg1AsJ1JHeXS33eXNBK4l7d8c1GXga5BI4fZTe1vBz/Hbns
	iJEu9FbAFk2OxP/54+8XqWnyn4VUJ07chlIyG4c12fFNUFSw48gVRy+bRCSKWzMAIHq5BL
	HeuZ1XNYByZ6mAy7K6jXIwWItQ3K4v8=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v4 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Wed,  5 Nov 2025 10:42:42 +0800
Message-ID: <cover.1762310125.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6EA5AC000A
X-Stat-Signature: gc8tuz53s363to88xu6k98hy1ms4hodc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762310582-723659
X-HE-Meta: U2FsdGVkX1+u8cVf6cD8WUftK/kH1/Ud4lxvMdQOXVzyuHxIQTph0YeFuSYedyJRP+seygJVR+l6Bc/7U4jxurVmG1R300yvwHH4VcgQxu52aOSx6ufH53r2YdI5cefNX2qZcjEIrXsy8HW+kjy/HNltGED3M+pnvPetEp5Ohn3420WWt3LYK1P8M8Q6nA+yTqkdOo+0kHY8pMS3ifCX4HBWI3f2JZjVIm9FJB3PEW5QtKg8zjzEZSL+30CyjUaJUF+/RLDKKOrdQf1v55MqkeF1UcL/gnZQ96J3GxeVGzxRRBbTmZ7pDMMDyGFYJ5fK9EnscRAdul35R+Pp5DTNyIbZKbdPV8IG5aumgVwhEMStNYxezBSo/+B1WSbLl1BSST0iWGCrPqJn/kTVHE2v1GNd1rrQmYCinQVMxOWPrjhZeLuneAabSQdxvCjqyUGNWqPdGq4/NRuTYE2cv3xDJ99YrcTAIMtjRrhkKBGTKxRGUnpVq1q5SpSF3hSW8Wdb+W8Fe082D4m0weMhVgkzIQrquyRWLFOE7+jRQRMkuyw8zJ/RBdmzxQbIUHuSDRMDhbYxXU5v+0eoRsoUHuMc2NaFSpFxiN5VvGciwaGi0ZNmOcIAQAQOUiGO8glvcsi5lGD0Lh988Lra8xMBU6DtXU6QYCh64qaf835P8sK5Nsy7C9P2zyj3xxXJ1NOnKf9o4sZNBGmg34skBy/CGIh4aqfWXUK72dKxPZvUB/7719fxN4Xr7eErKq+WfuxPSbW5J00quEYlqa8yFrA86cxBAFEXHeHd7TOZ7jewIyzYfFgjnCm850fruNYDtvWEm3LCZ0zcrwXJz6yvaGAvE9pqgwmQbOW/Si/HgGbb35J4rgHA4XAty5KD0aoZomKj2u7EOU8cjBRUs+MD3WQXnrK4X1lZO4x7CAA4r3cNexFPyeKoeUYVOOKdW7nJOtJBJdpN24NumPh+f5Uu+1r0JLj
 axRTx6vE
 PSQvUQLJUIewiuAD5tRREveSLgBUZINWEJZhy5y/4ElGJMo/QJtP5wt4oTxZQQtiQYdVpvQBD9xnzFxCZywejqSznSsWUqeQArO+68vNP5yn9R+mAvo5nm/tPxcpedGYjwWpF8j7pnMgUdRSqqveE3nU1JA==
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

Changelog:
v4:
According to the comments of David Hildenbrand, add copyright of
hugetlb.c to hugetlb_internal.h, hugetlb_sysctl.c and hugetlb_sysfs.c.
v3:
According to the comments of SeongJae Park, updated MAINTAINERS to
add new files.
Removed the wrong copyright in hugetlb_internal.h.
v2:
According to the comments of David Hildenbrand, removed the wrong
copyright in the file headers.

Hui Zhu (2):
  mm/hugetlb: extract sysfs into hugetlb_sysfs.c
  mm/hugetlb: extract sysctl into hugetlb_sysctl.c

 MAINTAINERS           |   2 +
 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 852 +-----------------------------------------
 mm/hugetlb_internal.h | 114 ++++++
 mm/hugetlb_sysctl.c   | 134 +++++++
 mm/hugetlb_sysfs.c    | 630 +++++++++++++++++++++++++++++++
 6 files changed, 890 insertions(+), 844 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

-- 
2.43.0


