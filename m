Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2BFCCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5128E00DA; Mon,  3 Nov 2025 21:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DD08E0058; Mon,  3 Nov 2025 21:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAF88E00DA; Mon,  3 Nov 2025 21:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08DB48E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:38:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A082E1603AD
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:38:51 +0000 (UTC)
X-FDA: 84071366862.11.EB506C5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id C605B2000E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:38:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FyrwYbpY;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762223930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=naNqLpq5EZqLzFsmkG6IghppzeL4JWW6iNluOrAWyLQ=;
	b=0/x4b7qs6XC6Bo2XsFSyKA/O0xvmDaz12ScSCqLcwMZEBFmFry9lwosqJkv5EBM5CgZu6f
	DGJzFbT/EwA2wfNLeJjOINd1qNjnibif8dBmPX6fd1cNnj8NyY6wX15SvZ/kR8okn7OS0O
	aSqSIqaKXwl5/p5hTezyzVDzXSVXiEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762223930; a=rsa-sha256;
	cv=none;
	b=FjTAmxnMVrCLnaR6Lu36e/AVF76NVcFm99IAVvT6a7jc5ENg/4QHu8IgCEJIBNU7tNQX6m
	/P/sAj9y0wo3v+UlfcOMHqQYheqCrgndAOdlcHdDapUhNHiSVPamNA/pVK+Z8IQQO96dUA
	8/oiO55x+4boGpcOnYtDmp+q1USE3fs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FyrwYbpY;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762223927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=naNqLpq5EZqLzFsmkG6IghppzeL4JWW6iNluOrAWyLQ=;
	b=FyrwYbpYuPHIrpIxEsmYDIsj+sUsu2x5fLT+oIolzAeI9FW0vn9A24aThJTQN7BSH8rgFi
	QSG0lWwphxjynnvKBY+/C3dYKViRH1aV8Cd4QDZYulgjPrexxc+PlyP+hGARydzVPLIQH3
	phLmlYtW1WucGRtQAuSccJFtwqO3r74=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Tue,  4 Nov 2025 10:38:31 +0800
Message-ID: <cover.1762221536.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mwqs7bib3kfoxk5ztsk45nkdz88pbbhn
X-Rspam-User: 
X-Rspamd-Queue-Id: C605B2000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762223929-858235
X-HE-Meta: U2FsdGVkX19OW/vkXTRVCg6MgPLvpOdCyldw9a1dQ02rtnI+hn8dDtlFta8TMspxFR+RpujBnL38c3aFGEpxymE3m4ZKoejCEoJW/5R4vOsbadnlRyUfuFakYeXnF4i9GVVjpyrutNvPUeARlOpVMf/5D54tEkqaJ81WtNp09fY1pVKIqrnhqw4puK6CdVL3bn6uVhpVEBSC2R/TapzCd41MpLsKxG/ujphLJNJmnxhZjy8i0FTwJlUTVRH0Fn/HV1bDDIRbD7RyiEUOniKD232MJPobNGwK2+FkTyB8OjaNDbS1/zqYI3RtK+3NbYF1lNu/lUR8lBpGGCf3ziWH6eKRlCnYpovOm7NyTRNLpSVQyISCkqHym0wMRm6rMSfra324ocEzA9QJ3bNoPthPAOBttDGDajFD0kFdeKZZCHpjkAWCmsBsN5jT2l3YCFpG3R+f1aBGuHkGqLLxayJEELXZXH7Ysi042WTzWvj9EhZ7gXLlPsZPmKvE/fZxw6mndiu7p/M5bxUkKVDzqaPNVrqFTbIKsV52g/HSbkHMLaBP/8gA5uEg6MNms+Kiodj2Jq+/0rLq9dQoxK8fW8EkWTSV+zFnAr6PeG7GV+EUNjaKgxqVCtnStprzM1LrW1eFoFv+zoWhGo0EMzBW6GjjevnFFjwNnDymCwf2B55FOxca0qG6aKoeH9mTLhId8w1IZHlCSNfyuX5tTnl5+fHt1tLpCrrupIc+6cveFUffdwJwX+dBAzR2HgdYevuryvodETNRQcxBwlhxyLbv4yY6AHZqqy9n8QIt7MQaBozxRaN8q7ievsrwlLYbUbsrb1Ab+uQ7wM6FUlqZj18nbRvSaExmSZAd1eKEgmIt/jeX2AOBbSGfB1Qv78QKhWmzDj3TOYua/tP3sGG4V0i2+8QMMg+kUlrPnJ1VDlr0gYe8ZOhtwwauTtZP/QhvPdTT3Pt68ssNRdSsNJm/wFefQOw
 KloV9D+G
 0jGGtos45f9JZnlgQmt8qqkzj0ZjLn2NfqDyxInX4IlcVUx3GkNreUie5XjybkWLyzvZDSZfpWE2/xeAPQa2WXPIzbqgOpbRjE94N7qfLFDVr/6vejDeRepfOyuV0JdW2pgMml/tU0OIo2KlTjc3GoLgW+XQbrO74/riz
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
v2:
According to the comments of David, remove the wrong copyright in
the file headers.

Geliang Tang (1):
  mm/hugetlb: extract sysfs into hugetlb_sysfs.c

Hui Zhu (1):
  mm/hugetlb: extract sysctl into hugetlb_sysctl.c

 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 852 +-----------------------------------------
 mm/hugetlb_internal.h | 116 ++++++
 mm/hugetlb_sysctl.c   | 133 +++++++
 mm/hugetlb_sysfs.c    | 629 +++++++++++++++++++++++++++++++
 5 files changed, 888 insertions(+), 844 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

-- 
2.43.0


