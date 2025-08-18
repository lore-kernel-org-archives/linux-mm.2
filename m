Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00FECA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FFAD6B00A9; Sun, 17 Aug 2025 22:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7996B00AA; Sun, 17 Aug 2025 22:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED616B00AB; Sun, 17 Aug 2025 22:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C63B6B00A9
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:29:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2797160728
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:24 +0000 (UTC)
X-FDA: 83788296648.08.95E1137
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00587180007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cEIXXTIk;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wyadSzPggH+QxJnbb3GNFcdkcjBsgL4zL6XHtASMwYE=;
	b=jXFEVmmKlT9aFREY5t5y6oDYaZ4RnCXymo4taNxFVoOxrPXTCxorrWAqVJoglJcuNvahb5
	qF+YbjQQtiyD/suzHhG/gwOe9FUbAHPsdcz1cs7Zpz5AiIyZ5JTzypkBaJRQ0mYuqNwce7
	1BeNHn+CKu9JlPiZYkdixCWADnYWIGI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cEIXXTIk;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484163; a=rsa-sha256;
	cv=none;
	b=y4+ROBRJTwIMac7bJ6b0rAwSTQ6BU5fBkzbiK00wGLxBlQEuSeB4+5drIUB4j3zzvtKsIp
	45TfXsEP2J44+56t3qFwdIG3TjL2JLYA4c9rSny6+Da3WrUCMabj3VbGVcHtFvQCXFG/uL
	pDAwJt7QDw/NcJibYW1aCPqcHkA09Ls=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb79f659aso550607066b.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755484161; x=1756088961; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyadSzPggH+QxJnbb3GNFcdkcjBsgL4zL6XHtASMwYE=;
        b=cEIXXTIkh39VYsuEGwBY6ASJ3cv4afoFUJd655dd4fOp+CipMCURpL9u6rnlyo3x5p
         LhsgEVD1v0LTy1oWsLnJo9P5oFsO3W5nQox3WcBMwE9NgvKi0jVdpouf6QyDEWAwjNIX
         MKoOhKkfHi7A0atnIKGVhj7pwOP9CHlhVSj3XaroCrE/5rysn2W72dEvXwwh0aKHQZ+D
         CY1UakD3ILCXqVkSf+k1MK4BuFcq1GXgwJEKMAF7bBd+/wFcXKxtRxOVrlKPEE0Hq8H8
         4wbX3FkOjUP2lG2y1Fagijia/ttZkJrn2XXjoRcBhoZF5tnaJOIhWaeQ0I0Lxl6bLWPx
         tnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755484161; x=1756088961;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyadSzPggH+QxJnbb3GNFcdkcjBsgL4zL6XHtASMwYE=;
        b=wAALMweI99jOiZASY/pJ8kMW/k8n8JSA7mWhDOWfYLnymMXqDCDR1JhZLCKtWJA6pn
         Q4ndYQ/ENEEyklPCb7IpGe3Ewg+iAjOzhc/VuvheVxdbVSmDRA1pnTcWUnZkki1sdB8x
         udE7hk9uFOVYAyKxaNnu67dRM4RVBaJe+P2XmbyFihUUlyLUWO6DgSR+030Sh1ZN3k47
         RcOEknYVTV75SYvtWG7UT13v5To9z5XetgHIbXsfkpwYn1emwo6wy3Ji0QgR6gDF6HLU
         DmckBVnb9hdsJo5jpJjGhexjNSB74PCYs2kgWVmq9zAUp2HIUKz4RSSKhsRiqjaoNJti
         /hbA==
X-Gm-Message-State: AOJu0Yz8dulpPrVWS2iIn0X1DyyshKAsxEWatiDf780x/T1AjEvjVTOA
	zXJRIEwq+0tWQ8ihQWI7vnI/J/CffouAZQFlEGYIqTeDw1FdfeOkpP8ZO5avFa0L
X-Gm-Gg: ASbGncumRhW7R7DUUPLMC1QSx88st1S2uuz9lUYlXTrA/CuuJ4oRpBJYU3IlykRVU9N
	UiwJ6CnsJ5+p9n5Ty4qZZADmUtEbgE7zJNqkOqrmSmix2gW8RcYYKR8p0nzdvAYyeYBlUbVDhR+
	ACdpfZcpDByXtXR8f954YImH2ID1XNx5L/draFS4nuyheem9TaaSJODjnrApIN6FV07YU9o6RMv
	6fbvKsZS3/S5yQDuof6A/ADyoWdJnuoZf7PXzlRYJABGjD7TBfq6iGhwfv8SlMomG0V+6AMe3zK
	OK2aAl5ABzkr50FnyvdPJMel9rMdu0djZRQdlNlSXgcid2e8OGpE8KrBHAWbBUW59SLSKcx4t4T
	yiMXufzU16iSyjVTuws8RDQ==
X-Google-Smtp-Source: AGHT+IG0DQYHvuG+jv2TVvSxVZaWrasuSFWynHFmIf7vi6UCBqFuHpzcZHuqCKx/cPPqnwv9gL9fiQ==
X-Received: by 2002:a17:907:9727:b0:ae0:d08b:e85 with SMTP id a640c23a62f3a-afcdc3e9a06mr861203666b.61.1755484161361;
        Sun, 17 Aug 2025 19:29:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd0104a4sm702355166b.87.2025.08.17.19.29.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 19:29:20 -0700 (PDT)
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
Subject: [Patch v3 0/2] assert rmap behaves as expected
Date: Mon, 18 Aug 2025 02:29:03 +0000
Message-Id: <20250818022905.15428-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: kbonu58s8wsfwk1mo38x4qrdwopyyftq
X-Rspam-User: 
X-Rspamd-Queue-Id: 00587180007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755484162-192503
X-HE-Meta: U2FsdGVkX1/58OKILVOgwSHLG+Nlf31wWvS1quJZB9HxSsMru2F8OEozjepfOY1qEqW9zFAF+I4pwHA9PjEzAgjPNQeSMabC8Uidkp+dbY39NQG6ftT9+STb0L8ePNhUSAmRkkkyvqD2uUZIGcaxFpMYLO0VJVmmEERrMCUVqTk98Ystm/gicO9fwO5J72ojtgx6EJnG7s3Jao1Uhidbp1kInzJtGIG/E9FE6px6Tpzx0ExivvudcdJ8o/Xcm0SEvjpehW1z9BJ5cjKev0AwnzFb8Z3/31sGDN8miODWre/OgRJevJGqagro0LHtNkalI+f2fwLKZDAE0mE2CC0L4kpMD3pVQoh2P2RKr0pHRoilYOu+IwFrd+TaijfZR+C4aqhwZ2G8Lht8Q6IB+IBD/k8jvuVArxBxWKzKkpWcU33buOLfWfK1jei4TaBsLB1G5T+vmc/dudCCQZhfx9iIqxJDxjHYvImWcGyqUWD5iorXOxWdc4opumORrLKW83lI9qxrv9g41GiM/NfZ4wJDJf1FLF21fqxjNATIYrTG9EDSru+/MneSh6O6JyeXdmID8dbaTVFKJ6u4nXZEK6D207vWXSfX5Y96hSTK4BSxvYzQ2m6lLmyPIUoLq/GGiYM/AqMr/KCezwPfXO/Hen/+KYjt12hJpnP8Jjfco4L5gEY2mGjys1n0ojifUNqpdvh9uAXbSfAXA28NqHMwMMoqfQgbopK0k5yuP0qQNdFM4KORjL/BJ0rFBB3yfpWVMw1cQB7Vfc9qj+Ot76cjOV+/vmu++3CatqthUP1oiSByd2I78PPs3Hl9HEOj538bBb9a//ZnsdSIcAjSgRjKexsb3zP/RZnJJV3IgbHM7/cLSd/tOvlZjLGvEvXIGKs+goJegUCbInYZ6DfQJTVXU2+aMZ/dCyRa2+hAydm+KYVlJZ+kA/bQ4ZvB7VAuUsA07osGqdnDagykq5/+6UAbdkV
 Qpl9bqDw
 iSPLvvIg+nyDXwRUlcujn9YBLOtAMR9mwWhLt3IM3f4O0PZixraajf8eRgK/e7GSqriDecEec7P95kW2z/uFlxMesIxzI0Z6QeAqKR49EFDGbhWzo/GCtT8NyA97Tzgss2OyOcnfIUi1MHYJv3FUGCw2kq7H3D+k1O751rT1Aerx289Vk/7xw/5cVq9s2p1ADRT3mGXTaNBkFmVQPXpyNrdp1LOYNK9AvNXhMr6CxowUue3Tt0kxu3thJLuGfnUSPLxsGCNtWg0WkpJ/CWtNUqSDkJ+1RQCJdKioYYKND3APX5Qb2dVCEmvGI19DdcUU1orbdHuir6DIQFBjqzSwUZ3KACZ1Hr64c/9vwZJY/YdL6vdudx5vAWh2nCRkUvZfLt+e8dXRO7wK3QYUL/7/dcA3kS+Mv3gv1+HZ20Q75tZsiclZDnCops2ge5hHGOju6gea9LIsMmCsP0oP+W/eS8DdL6/Vt3qTcX1GROOZBUl9aJAou92USVEMBhg==
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
  selftests/mm: assert rmap behave as expected

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/ksm_functional_tests.c       | 134 +-----
 tools/testing/selftests/mm/rmap.c             | 433 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 tools/testing/selftests/mm/vm_util.c          | 123 +++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 8 files changed, 595 insertions(+), 111 deletions(-)
 create mode 100644 tools/testing/selftests/mm/rmap.c

-- 
2.34.1


