Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C080C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45316B009E; Tue,  5 Aug 2025 12:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CED76B009F; Tue,  5 Aug 2025 12:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896366B00A0; Tue,  5 Aug 2025 12:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 737156B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:20:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC9E61A0125
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:48 +0000 (UTC)
X-FDA: 83743217376.15.F97F7A7
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 39C454000D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqTtW3Hg;
	spf=pass (imf12.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KPqctxuj25XobMQhW4L+Lm26tm0IYdYeYBgTx2rSnRk=;
	b=MoKCNibRDT5h5TgKyM5+alBZskUwtck7aZpWYrt/1mOoLoJ0AsGu0tcu9z/po+qQ6fWl63
	H8AwVR916WPRZpzhOOTplkFANLAt8io4Ti7AI22eFqDRABHCWY+9LfvNLYxFUEWNJL/6jb
	5Y5c7SnGkK5hVH017AOkX+Iopn5H1P0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqTtW3Hg;
	spf=pass (imf12.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410847; a=rsa-sha256;
	cv=none;
	b=RShKgBiVTySM+g5qcPtcSowT3oUHCBEoyYC41PiR+yDdA2PWO/6tP6GGZWS7EornZG7ymX
	NVIs5Gz6WKri8LbelUg7WmU5qsVnBN63mHt5DRtMrupap/DVM7j1vdzJCUTfR1UFcloNem
	Mg6o+cLhzg0A1ACmZJpEv8PbrFDZ8uE=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-710e344bbf9so46762837b3.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410846; x=1755015646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KPqctxuj25XobMQhW4L+Lm26tm0IYdYeYBgTx2rSnRk=;
        b=KqTtW3HgTPcoYV2SdtFlTT2k2GHrTUZXZ6eI+NnoeZgw+6XhdqYuI92Wm1Oroc6HCL
         51XWTy1LA+iuP1etzDp5CcCp5Thg2YCsd03XVSSXFbL8UTq7E3z5FS7zfPig8JT112Tf
         Z7dZi1cwNcCBry3fErXEjV/DLlUH+Ow6qCfWK8t/tR0TR7T2Z4Dv+IGxdcqwX2PsBMqh
         hlNLz2HWHp2seUsR/FAjKzmB+8QHMFL178ektfvPkgRVfomIc9V9v1tFbvfG2min+/Eu
         J1s/ZuB50I+adMuA2+AlqAWux6ARPfBWt4AzJtaL/B/sYmSvRvbs141Gs06hwqH+ryL8
         Gm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410846; x=1755015646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPqctxuj25XobMQhW4L+Lm26tm0IYdYeYBgTx2rSnRk=;
        b=FCGjsyvdXyLWbL/Xux0IXoQ4dsAxBHiUW0OZAVflJzYeHSTEG+RJpgY2TUodFGE7dD
         x/etRmpiuYn2O2Mc4YocKJhLyXPJKS5o8WAi336QzCqw1joDHMMWLa4jAd4l3mcPWYKI
         bm32JaHE1cKKh+aTCrbUADIWYRg2KKZzt1dviDcHndTexHRd9OR0G7mdfFQrUl/l+rAM
         VaQC1SCo2hN1frTxfhc1okJoxXaehKEDPUqw+2iEAFSrG+mPa0l/yXGZvcQEr62w+9nY
         UOgLumcL4jdeHMI9/E4i6DO8RQSQbivsQ0YIMJLkENUHbIfq4A2JorRJMT7RWFvI9PBW
         ihLw==
X-Forwarded-Encrypted: i=1; AJvYcCWNNDmhOHa5/HxbPWnUrZaqfy8PdiEmtOmv5y6JlUHWsWsa3LSn+fs61zPar1ruoZRpDctByVQYQA==@kvack.org
X-Gm-Message-State: AOJu0Yx0R2loXTi1j+oAWGh0Q4Iy6cz1sExIApIUlH0c7TZqmdEZ8jWx
	NYphPzeUNm2scWDKpF/u+3guhOD+vfebT5TCLERDF14bw/AU4RNemjeN
X-Gm-Gg: ASbGncsYZfwzeqNnNNsMJBZunSdt1wUdGzG6ByOT4o2dqqsVYe2dH4EAbbBkHQfMp6v
	M6wL58sodgCVsGkf/PowRxxn2AOhfZFQz5mdMK+VcrFUrYdF84uz66oYi0oNbsqAvSwSzwdhccd
	KXlGk62g5oRxWFcJyZ/8EKe70gDikfoDM4IinSMriLJ1wtXEyiEfOGh2HChHB6VjVaGKlpcXXtn
	kTtE+FugR0i0KlUui8fSzt3YoqqZq2HQWc+arAPvyWQ4S1KgSiD4HSeDQo5yxj1cFZ/x1c7jztl
	kIcAsGSY3l2Av+UvjjkVgxGdHxEoj+r+v6Nt2SJCfpgg3mYv9/ymhYXMtoZhOmSBD3Z8oy/KKJS
	x7nhJF2L4sheRmyANcmM2yD42iKsR7dHZ9wsQb7h0csYWsGKKCUniGw==
X-Google-Smtp-Source: AGHT+IE88seSdzpVdkIzCqTZrsRMzATgLnxXnAhDA3siqgjEUV7PlZGlyUYJyltEuCGK7VDVUQpqGg==
X-Received: by 2002:a05:690c:a0ad:10b0:718:96c2:b426 with SMTP id 00721157ae682-71b7ed887c8mr121416667b3.15.1754410846171;
        Tue, 05 Aug 2025 09:20:46 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:20:45 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 0/5] mm/damon/sysfs: Add commands useful for using migration dests
Date: Tue,  5 Aug 2025 11:20:17 -0500
Message-ID: <20250805162022.4920-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t87kfhjxwq7cnkhi3fut71bn1zokb1oz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39C454000D
X-Rspam-User: 
X-HE-Tag: 1754410846-476708
X-HE-Meta: U2FsdGVkX1+aM4s/c2a6US67GaPKoJGH6+rABQvcBy/Ho9LYui4b9IEGx1Af6lMPHN0VXYY2MLhgp8nyYcODUov+2u/EHyWvMw3YBBMpVnaOulCdjaMwqwb4TgckEefEYL0JgewYDnqVQoMGS0hH+atuXqhV051S3oO7S+rrys9BxYLPqNZzzbbruugDUlGGdp+SJd21WR9U2iejyusVzEBLpklYxmy2LH6kCzJAzHPHm2AopcQJTZsLpsWEWoOwFEcln5M5hb/sCK8TAOT4llQFxMrClxuDx6NnIgx1HkGnb5aoiaG7srLP1pjbMOrtFn+3QrFX4KwS9I8Iz2ZZFg/j2yW813V2zhBnpN64rqpRPnCLBLYQCRa3QFutoRYsQRKdN4HlP4UQn2He/lmKa1vnatBRp+t1+S7QUbga2DxGnDbAURJSsfwIE7YLfZB3n7v1a7ZznASI+bzVvr4kMP2/sxrUZk1FjFJGY1v91OhqK/tFS8/Bzm8b18H4+fERYIzg86/76/GoGzNN6sH28yocRSknOMNNfyovKxK3eF5jHNyw6yVxnCVO2PFjTqbXIShxXBkreBH4TQc50VcBoX5kopNReebDjv4ytt3jvXvPyhWkeFFfc6PyFBy62YL9Xv3p/54qnmrro5vmUoOS4XuJVRe2zqL8s22iEXzm1qmWfrVhwcpRVv16t08Dzjrk7f1ncAmz65feYnlfjlSg9R49ZvUWzpCXc1vQ4lvFtYCbOr97+pXWkQpeWm7S7UVgr0g+lXB0tyW3xXOEvZHHZ2XM6oYvTqmxbXxLjBDum8PWzCVLj2GFyywVPwUxbQCBiteX1U4/4+jk04bQBtT7VvDDjwk5c9lqQXjjZqhkMZn1cSr2G0w53Yb1kEgZVFYis3hsV5eLXAY77ulfEfqVsY02/raCMJh3LMeD2JlXKxgdXplY84JqwJd5emphgmogBNvtOwtz9SzeB+b6KB7
 IVUkGHMX
 ftl1xMndEZUXmWZaSsvK1cLLgomD09bNiboaBHDynaU/QZABrWj/9n1egCmdBSmxbSixfVy0OEDpxWrFDCP4qdJjFOWbxSEUVmlYn9ipOt4KOHUFkbNaGl/ByexEmdC5bhpQuWfCjJwn3NVfZEkVf5gsju3HyEeXLsQysj0wDAwFdSt2TqoCihseshV7EOnOC+e2t8piw6Xnmrm0CqDJiBzw3PuHAzD0JYz7hUE0PreAuURokhIn/psWNiM5Ih8wq1tXgbsl4sTk6cAvimAWtIQlDiARNYv2K8A7Ab+lyoZ6p1MhHEG3XEfrZEpKEPwAUj/ooV2065ZSsu65WXXmr23gb0N0yFzCbD+8Xp6xabwPau0ZRc3Crhqd8p9RZTYHq8o590JJF1fqE5HoSoaE6bjArr9OcHck/hjjIAqar3v/OjWMYTIG76oHnNb3D+BSOTDR2yyPYQbOzOahyzmq06jkn17WE4pldXk7+5o/ZnaTlShg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

This patchset adds two DAMON commands, commit_schemes_dests and
wait_for_schemes_apply, that I have found useful for using a migrate_hot
scheme with migration dests.

The commit_schemes_dests command, similar to the existing
commit_schemes_quota_goals, is used to commit only the dests fields of
schemes. This has a couple of benefits:
1) It is more efficient than recommitting all the DAMON data.
2) Doing a full commit resets the aggregation and ops_update intervals. If
a user sends the full commit command frequently (relatively to those
intervals) the aggregation and ops_update events will be prevented from
triggering. Having a separate commit command side steps this problem.

The wait_for_schemes_apply command causes the calling thread to wait until
all schemes have been applied. It does this by calling damos_walk() with a
NULL walk_fn. This can be useful, for example, if a user wants to know when
new scheme parameters they've committed have been applied. Another use case
could be if a user wants to record the system state every time a scheme is
applied for debuging purposes.

The functionality of wait_for_schemes_apply can be achieved with the
existing update_schemes_tried_bytes and update_schemes_tried_regions
commands. However, having a separate command avoids extra work and makes
user intent clearer when used in scripts.

The first two patches implement the commit_schemes_dests command.
The third patch implements the wait_for_schemes_apply command.
The fourth and fifth patches add documentation for these new commands.

Bijan Tabatabai (5):
  mm/damon/core: Add damos_destroy_dests()
  mm/damon/sysfs: Implement a command to only commit scheme dests
  mm/damon/sysfs: Implement a command to wait until schemes are applied
  Docs/ABI/damon: Document new DAMON commands
  Docs/admin-guide/mm/damon/usage: Document new DAMON commands

 .../ABI/testing/sysfs-kernel-mm-damon         | 21 ++++----
 Documentation/admin-guide/mm/damon/usage.rst  |  4 ++
 include/linux/damon.h                         |  2 +
 mm/damon/core.c                               | 12 +++--
 mm/damon/sysfs-common.h                       |  3 ++
 mm/damon/sysfs-schemes.c                      | 35 ++++++++++--
 mm/damon/sysfs.c                              | 54 +++++++++++++++++++
 7 files changed, 116 insertions(+), 15 deletions(-)

-- 
2.43.5


