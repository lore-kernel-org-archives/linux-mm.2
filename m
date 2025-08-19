Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD69CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E3E6B010C; Tue, 19 Aug 2025 04:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375C06B010D; Tue, 19 Aug 2025 04:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B906B010E; Tue, 19 Aug 2025 04:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14B2B6B010C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:01:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBE2882E1D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:24 +0000 (UTC)
X-FDA: 83792762088.28.D2BD578
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22B371C0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ci+WeJ0T;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590483; a=rsa-sha256;
	cv=none;
	b=fdNjUWKysvzJ7E+j8P0gJbYzSnsZY7w7xElNU6LyoQkrq5Rhcx1Y6IGDKTOUC6Uz8euIrW
	VE+LAKsNtgvJ56D4jM/OREB4IpmCJ1KHII+yIs0XjM+FczCJDugNRGrbLGEMR6WuvEFsf9
	xQnjDOGkF70RM6KiZSQdlkEFwq2QObo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ci+WeJ0T;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NttAVGS/kcZ6hlvGlfVRJ78tj9AfbuwLK6+h4J2zKbY=;
	b=ffQRGGUw0UpaKzDsN2L3WkRsQ7cS54YSZMs0MAUqTmB6P+IycJVhKE29C3ZU8qwG40Lpbs
	TZ0I0CXokzK6eaR3d8BVgwsNRnks5UCiQDU19VmxpFVvaj65D950H2Q6jUX66dMVsNG13B
	c9kye8e27FKjIDMiJKFMySHBKfVwECA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so728296766b.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755590481; x=1756195281; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NttAVGS/kcZ6hlvGlfVRJ78tj9AfbuwLK6+h4J2zKbY=;
        b=Ci+WeJ0TVOmjecEbrRqDybaQ+MFSYgnFPdbggSTKr4FrHcyTkqd+gVhFLcAgn9E304
         Astaiq3csECyzI6VZ07ff8wNPSHSBrghZ8j8jG9BHOm+7vlEEv3Zd/mvGxA9KdPsPM6b
         LBlhnl3dQHg3wP6QXYhzj9MVrTslHCcWDp8xeTPrSUZb1AbgHzIYefrkMTRsU4hdG/fp
         ney+nHk++TIykFt51OWA/KlMiKtRffvzD0gLLrmh11oNeGatOIyYUFNPReLpTxQKc41t
         kNllX/aiVKjc+1gnvBbK6YbL+HtVGW8FTzxhfNyeeF5SgJIAiDyo3dfPUr9Sbf0ZZOzN
         drWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755590481; x=1756195281;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NttAVGS/kcZ6hlvGlfVRJ78tj9AfbuwLK6+h4J2zKbY=;
        b=Ej68lrO8tM4CoUX1G7ymcqAkdjKVy1QHFByRBd/pDEFUdxFYRIY9YFSK18SsSJM19B
         BQY4VNCjD9gqDXqZUVB5gRUHfjjbqvWh9PVDUdISz3ag+F98rbydT02u8ZE0NG5MoVxX
         BdxQARNHNRmR3b9t5bNcQiuiMBbnjbsBh/YLB++njM02xLUfXOW+D02azMUUTRnrl2K9
         8c5aRdjv+mNDlf/FCktUiLbNGHf4ERYOgWbw3C9qbN9uMW27T06OFwYtswVWiEuGQJrP
         JGGY7UooJfDW6hdBY8tpwtvLyIGKJJFoYFfvGun5KydR3K0VKwdAX898EFdpBJSreNvh
         PEwA==
X-Gm-Message-State: AOJu0Ywga+ZcMpEgNLF5uOySCebC47wUcUKYllxFlH37x8KX6VMAEW2R
	jIUiaambxeclO2fslizHHvnwSQArO2X5T5BZIkZXyCdfwUqnOxBbY9gy
X-Gm-Gg: ASbGncs4gr5sWEDDUkJr9+DWjf4g7oCbWplWIp6enyDpNdq+kAQG2jLM/Tp2eqH80Cx
	bHbqZaQBSvDFaxhnlZAAUuQkhZ0976sATEv9B79dUZ8ULQ3dX9H4DODZH2wAABKwsw7j6IA17+5
	KzJ0M7St0gdcTXkWhiCc5LJMnlYBpBT0sUl4zc5c4jRWOKkf5tp7CgRaRS9iJ/QpeIVMN0rH0Ck
	rxuOgJG18zYE12Pd22wbpdSsdUgNO0tPIkDh19IesXBWfvCveU1RY9dGyNC0hThC9Hb8mnjcMHz
	6HTZh3TFoYoe32iaICavGnrX+xefTAR7FhnB7ryEEiFjuuhOPg62anAqSUAh+lUorJvNKaEXvfY
	mTgdrmDABc4vNUW6q1o/oqw==
X-Google-Smtp-Source: AGHT+IHfZ4gJXCV35zyoWZxt1c6c/l2A0KwHyNY18HT54S89W2xNZNz3Owx4pMwREM3jmcHj38yfLg==
X-Received: by 2002:a17:907:3f21:b0:af8:f9e8:6fae with SMTP id a640c23a62f3a-afddd1fb9e8mr158328466b.46.1755590481381;
        Tue, 19 Aug 2025 01:01:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53f49sm961046466b.7.2025.08.19.01.01.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 01:01:21 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	riel@surriel.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v4 0/2] test that rmap behaves as expected
Date: Tue, 19 Aug 2025 08:00:45 +0000
Message-Id: <20250819080047.10063-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22B371C0011
X-Stat-Signature: c13c6hnmr11s3157oztnr14na9wbudj5
X-Rspam-User: 
X-HE-Tag: 1755590482-774118
X-HE-Meta: U2FsdGVkX1/H9W9Sftz8Z9vQ7qITe1S6mGOHlm5dS0DC0IAXaoLvJnO6X9w/b14lWNS2GefSwjzZbGa//e9MKIz6XFICI6uuWjk/IW3e/WzRvkbngTlOWPURWiPYzqJuc9bSOdqt0VwP1pUJnwC0Mw5bke3rOjM/3aSAgXIVJU+aZfFnGNfpoIn0a3PN+/FAMGkZvpVSQMtNZ3MzjYosWJkBYU928Iuv5l1gLv03LFV67jL1L8E8F/PiQ130LJSHf9tx8rBE9KbJRt5clpSovKUs2G/uiIhOfKiRoly7Uov4aSXbXX+2X9Rq7bohfuRoN0gaQ0xwZh2rA4difXL4+Rgyc395AYVcw14wM776o3PhcgnN/H4ApssxVnnDnzok/RO+dxi9jMqT2Y5qJjeYfjfY5/l/z0H+zhq7WBmo3JrnU0eEH3Yl26yaCAPLEm5xHS5yefB6Ka/r/YXhwyKDLRDktk8o5CkFfgNwXx1O/EggdItSyEAVjiauFDJf10XirfwxLfcpxD9nW1CelhX+JbWeTOgXZ+X/5zwJZ5GxMhqUrQI3R8EOE/qn9k6nS7lp4rYYj4VJRdj3phMlDgFgs5TobbkLvqgcP/r/qfKu2zcspfTmJSIC8aS76mhFnN67OwCK8yUVw6LrHLB+/Kuztf1twOJTKYWFaE5HUeiDMMtdVQqbdMA8bO3Y4ZvHtv2vLEjCxfIG0P4z+OZ1OR8pnQfmqVAkJhAQUKr+NmNQZKTEIl3awMeKx3nbUJzzw84I9oDcgxehABacx9WcBVpB4eQv42yM+kqJ8qdH5eU7FTILohenIJ5U+7/NRFwDSf1jYF0rSuyIM6nToNfL2v8Q1QIETyUVib+JapJrIh4GgThs8ICPgDRjYmwrOaJlvsz8Wz+c1dcovgcOv7Xt0+3tc9FTRNu4/zkeoPOzbS9Dd5he2fQk3hjeS7+PUgu+S33vuXxf57C9CThqLmR5FVq
 aOnteI9M
 5y+wXYo2RaHbv22FO3OFSw+Z1L3TVgkeVCyVqlkwAPe7y/UdANmcBmINtWmxXcv2vHGsb/TpqGUdx+MLRPj4+dIA00nF7mIq+gSQpYCdGetgD74ySjZS9D5dc23qsw+AMPFoT864P+B3sDVv7hogFlXNqxXGtJYl34H1aFwC6GK/jV6DT6hgsUePbwwHmsMCedFyVJAtDE+GCCIQnR4277Lp9JaOSC5k/ZJbA/ZSihUN/BVcrlvpYvDptZCIXsb2jRagag07USVm6fIUPmUQodga8AVHdi2ifAeMfJESjDxVu8g7fVZXgwhj35oA17jRZaOAwu7rSYauIMWaig4BKOva1MPf5sXN3gaq/9gS/9i14oyGb03m9EnIbsryZ2Fp9XRzzJaZtBeLia287i8zn7Ipr0Kdb1UB+sC29BwN7Z8NhEwY2ATst58YDpZV+QTpPCU4YnsvmgOebEPwleuMdjjH9IN7hJh6oX6lBrbj8go8+kIOsg6f/0A2v/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As David suggested, currently we don't have a high level test case to
verify the behavior of rmap. This patch set introduce the verification
on rmap by migration.

Patch 1 is a preparation to move ksm related operations into vm_util.
Patch 2 is the new test case for rmap.

Currently it covers following four scenarios:

  * anonymous page
  * shmem page
  * pagecache page
  * ksm page

v3->v4:
  * rebase on mm-new(dd1510cefdfe)
  * "assert" -> "test that" in subject
v2->v3:
  * handle ksm error return in worker
  * rebase on current mm-unstable
v1->v2:
  * do check on file opening in init_global_file_handlers()
  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
  * align the return value of helpers: 0 on success, -errno on error
  * skip instead of assert if numa not available
  * check ksm sys file before continue
  * use private anonymous map instead of shared map
  * check pfn instead of content
  * retry migrate
  * fault in region for each process by FORCE_READ()

RFC->v1:
  * open file in function itself instead of pass fd as parameter
  * fault in the region by accessing it instead of print content

Wei Yang (2):
  selftests/mm: put general ksm operation into vm_util
  selftests/mm: test that rmap behave as expected

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/ksm_functional_tests.c       | 142 +-----
 tools/testing/selftests/mm/rmap.c             | 433 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 tools/testing/selftests/mm/vm_util.c          | 123 +++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 8 files changed, 596 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/mm/rmap.c

-- 
2.34.1


