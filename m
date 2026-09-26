Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEC7C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 05:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E04D6B0088; Sat, 26 Sep 2026 01:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790D46B008A; Sat, 26 Sep 2026 01:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658EC6B008C; Sat, 26 Sep 2026 01:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3170E6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:52:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6A5D1605E3
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:51:59 +0000 (UTC)
X-FDA: 85254842358.18.CC88360
Received: from mail-wr2-f27.google.com (mail-wr2-f27.google.com [74.125.225.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0063BA0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:51:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LB4frlQC;
	spf=pass (imf15.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.91 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790401918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cuKCG/8Yq7XE4kptDjfwqIDbhWjCk5cWtvEdVchH9Gg=;
	b=65GW1L8ztkVFrFprL5cZj9i7zVYS/fjY9j/ifgF2GqktwfpmhPJg0YzO2aXaHIUpWlSCOT
	vCG7d0+pBBWrL5DkI490OwUHXue5/YjwJMIqxiTTXTtFQvOxo4kpjPgjZsnr4msdZH6d3K
	7DMKage3Xu09agJFrQBeOn80vVdqU7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790401918;
	b=US3uJ/jaT8ogkpY2ef7/01q+3Vf/CgfoTKrrBgT120CKvzNoI/lDAnykNTlvS+T4IlqbSK
	FKk5gZyVVVlgwiAOtNrLCK3kH1F4SZRqG5zpVcTCM6ggm3CPh56RWyMt3fljusDYuuKwR0
	GkSjaxglEna8D7nqbq+UcASCe+BgmNQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LB4frlQC;
	spf=pass (imf15.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.91 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f27.google.com with SMTP id ffacd0b85a97d-4843796e373so880590f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401916; x=1791006716; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cuKCG/8Yq7XE4kptDjfwqIDbhWjCk5cWtvEdVchH9Gg=;
        b=LB4frlQCxw1P4aVg3fNrfLvk6VgsmYXTVViEDK2v9yXQQ+O8Q9F7ZLrRPY3yuyDTxk
         T/qR6SYqiMOmBFgMCuuFuFI6jfmHweC1Ave29OM9v/d4rqhE38jlGsh9jcpRw2quJjwE
         FfYTUzvt52aTo6dGC5+jOUuw6FkiJM/Kdv9hM+kTKDpGQo58jTZwDYWvIjhVKFFoxPuo
         BD70S5PGbuPAnII4dD7FktvaaDi6UlkQYDsMPDIYs0ccoY4oaEcAp5OZ/e71Hh/OzJEM
         ZTiVVBGABnX90wTV8LBW/HN61RIxzBmROcpX3BpQ0ipPbReM8IoA7taQ7mlR6GJnn1RN
         nxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401916; x=1791006716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cuKCG/8Yq7XE4kptDjfwqIDbhWjCk5cWtvEdVchH9Gg=;
        b=tKZ3kNntag+LtbqTBdk9UPlzwRlXEUbcvHoLChSCvp9EnJDxsWIkTZ0IDc5uqQhHkn
         w3ueqwsfh2tb+FWgRbZsOEdPQuaFKnIutZQsKKNelgBiq1K4A4uLZpf4qUFylIEMWy1g
         OE+j4EZCcsgrOnxrvzxuEWx8HjfElprh4bFhGTE+P9FVn7gC4V0jHgeaiBWAoXHwqWIK
         VIyttIRMixRuNbhuxGf+QkPtK5iARkmJcv6D1aG+0ROhf3pdfWhyT39S6UCCRnyICZlo
         pXXS5TsU91Su8VfNtwRUoltXfMyTah7Xl/9f/b+8hVACOa8jeXvybjr+s4Esbeop6aaU
         5L8A==
X-Forwarded-Encrypted: i=1; AKwUvBwP/fi3jD18awfd1CXNDl9doIHdaHIfEH1PsOVQnZyYfUy1lWFpFS+kyn2BspNNZXn6ken75KWTCQ==@kvack.org
X-Gm-Message-State: AFuF++mAY+jjSQF5+C0RI2ChAdF4l2gKYmvckw5LvomJLGf/M2pBml2z
	RV4pfzxDlwvCx1SOi+USImFAZV76EHFxfybbHD/e0tc47t7BwLNPY004
X-Gm-Gg: AYBFou0yf9mkAFINSiKD9a16oe/v95RAo8MtT32MYBfuh1sQE6+7GkC9ROFg6vQoVkx
	kMRKeM/y5noEhkkB0+YAEA2Jd+XbXqIgmABvyEsRUE2MVEkR9FOTcyvnUVrOID7hCLKEZoaLlGD
	GU7vSvuEpT33qXnrtUxkKOTxPM9BMZz2JJnxuAzxECXuOW5zx8Lcb5bJzaFzDo5BMsSjaxOaSEW
	IZsEkGYE1H80xortw9e8q3Q3SRaH5Rsc6qCgbq+Dl9vXNSZZZVlbL18RclLexHEcCjRV1HqZzZp
	kFWdZw7+hNn2dDqMRWp4LmSM3EEbUuIKUSywOSRTbvJSLmz9QJGLkN30p9NlhDV527sIXUswvJn
	aHTce0S/H5UAF62PuWoBGPrf50QSOUKxodzH5U3GkDOgChyviOvBhaGZeOI/qOL2xZBZ13kXcr4
	vGKgh2AwJdokj7fGJopVfUJJ9NogLB7fuzqN87yHztZkz1zL7dWBIVeqlKWhZwbbTUxcbMQDKbv
	feFK5DpsH5s87g1kV3TWi4unWjW4BHqolO8/S+P3+kL
X-Received: by 2002:a05:6000:2906:b0:487:ff1:6274 with SMTP id ffacd0b85a97d-488716b290cmr15769328f8f.7.1790401916378;
        Fri, 25 Sep 2026 22:51:56 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcc4sm12317560f8f.1.2026.09.25.22.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:51:55 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] selftests: cgroup: Report failed checks in test_memcontrol
Date: Sat, 26 Sep 2026 07:51:46 +0200
Message-ID: <20260926055152.1684-1-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wtiuriro4maen4jmyzn61ganc6g49mb1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0063BA0002
X-HE-Tag: 1790401917-237924
X-HE-Meta: U2FsdGVkX1+IocJ09Vz2zhDttfUiOpOLuW8F9QFg33IxfacYjtvuwWtESQ7YI/WrtQtVgy4eCtDH+672MNGHT+FiscAVxe6TdEnePvMoZTL4ioE8FrzWZLsnQuBmZ4QPwhSfTvsqvkmpZYJWmZ9PvR0HKWcAeIbGulaL4dHh2bGtVVWS/sQDczVREq9c84dbPDk4+Zo6vletglwC2/LUtnkPWbcxndNPlyEi7x/2+FMCSTr3B3y1XcxuFvWCCAcnR5+FR6xChl/5jX/APWVn9Dma0XZdI1i6fnUaKK6SxpUA17ZICCsS5hLDGwM/bY2Zq4CGQ5Y99zethQ9QzJKTZ6LA5UIeEuNI1/Xqb0foq4bLzsaTDiZw23iBepmbRBn11qtxY5r4qpyovvia+v4fxI5RuQ0t+ZrHx0/sZMNet08cW4kMqN1M/C4n945QMpYSwKzS7cVUzlME6DENkar9S+2ynyfNqRkoZnn3zmAzT0afmWojL+NT9IqiXFiCHNy+tfkJ6lK8qetaoOUMv2JGzno2n9VjU836zH926MGpxfoZsL6WMpD6MPUjA0gliY6qsgb/hC6GQy5aZOrc560KIHS87aDJyT7ao1pXc6KmkruQ98jVwCZF8fkdPhvvsBaSCPQFjkLwkNdnKjrl4Xa80dz0dqSpYIv/9B1MHGW6tUeIiduCw/QMh+SZMTbuHN0jxC+f5H4XYS0C8yiWFh8oTCBeTAuvY1CPlo3zbhneZjftD3m9O/DSyOtaNg146+9iXd4ev19eASmQUc6ZU7r9uDfPnwdJpEDcSEjxYhXojDmLHzy7cftnXrsBWm0BGwB+uSdDI5FTz8Jk5uRzqDmFaUGzwGx2oA0p3WHJ8YcVUHQiu2bVWBlZdQvO+uPu8skrytiOjsemODrNzJofTtbEjyLLuJfC8VmJTH9/BCKbty1pEsLQx5vPXSZThM/FfeB+jmb4hRXXbChOjksAM/C
 i2GcJAhs
 GgjAgxO1YF0aUEPXYDRrMJGTUOynSGb1skWtf6W98YRhffKfmf8dS2nU25SFEb1v4kFGP/XckhEvFVXgzd4miHO/f9oNQ9/5XiiAU0RKCufSC8uWPCoFE1gtY0OD+RK0Lm4PfMZiZEEYKiN7qWtVL/6tcMlKNgXZ1iZv6F5WmG/M3KuG9Uv9BIJzFJc7RmkWXXvdQ4h3YAs9Q8vO6ACaYrR9NraKl3PNPKsHsSnjfuGoZ7DcqLe/o8Oh/BdA0UvmJ8f8LJ64GL0nsXK2GBOo+1yZHnplpNsyIvvtJTLh86cqmUj5JfSedAOmduwC83B/pQeHkD6D3CwiUqALzu2/IN1bY5tUObIjWkXr7SQLoSQbAEct4T3m4Rh0T33sZXhO2T2CP88EyT8Ya5F+fb7l9VWUDsiYpfx4e20YHjc7zyCI6xFl5BQMoDtIspqks+dI0N3rd25zI3h/qhvQso968ldDS74+9WDVkRucK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcontrol fails intermittently, but most of its checks fail
silently, so a "not ok" line gives no indication of how far off the
measured value was. This series makes those failures print the observed
and expected values. It does not change any threshold or pass/fail
behaviour.

Patch 1 converts the terminal tolerance checks to values_close_report(),
as was done for test_cpu in commit 4cdde87d723a ("selftests: cgroup: Use
values_close_report in test_cpu"). values_close() is kept where it is a
loop or retry condition, where a mismatch is expected.

Patch 2 reports the "memory.current < 50M" check in
alloc_pagecache_50M_check(). Because test_memcg_high() calls the same
helper expecting it to fail, it gets a quiet variant. An alternative
would be to pass the flag through the currently unused void *arg of
the cg_run() callback; I am happy to switch to that if preferred.

With patch 1 applied, we observe at times failures like these:

  not ok 3 test_memcg_min
  [FAIL] actual=18722816 expected=30408704 | diff=11685888 | limit=7369725 | tolerance=15% | actual_error=23.78%

  not ok 4 test_memcg_low
  [FAIL] actual=20852736 expected=30408704 | diff=9555968 | limit=7689210 | tolerance=15% | actual_error=18.64%

  not ok 4 test_memcg_low
  [FAIL] actual=14364672 expected=22020096 | diff=7655424 | limit=7276940 | tolerance=20% | actual_error=21.04%

These are the child memory.current checks in test_memcg_protection()
(expected ~29M and ~21M). Their tolerances were already raised in commit
d2def68ae06a ("selftests: memcg: increase error tolerance of child
memory.current check in test_memcg_protection()"), and the values above
still fall outside them. In the first case the child is about 38% below
the expected 29M. This series only makes such failures visible; whether
the expectations or the tolerances should change is left for a separate
discussion.

Changes in v2:
- Patch 1: pass the measured value first in the alloc_anon_50M_check()
  values_close_report() call, so that a failure prints actual and
  expected the right way round (reported by Sashiko AI review).

v1: https://lore.kernel.org/all/20260926034923.31718-1-sebastian.chlad@suse.com/

Sebastian Chlad (2):
  selftests: cgroup: Use values_close_report in test_memcontrol
  selftests: cgroup: Report memory.current shortfall in
    alloc_pagecache_50M_check

 .../selftests/cgroup/test_memcontrol.c        | 50 +++++++++++++------
 1 file changed, 36 insertions(+), 14 deletions(-)

-- 
2.51.0


