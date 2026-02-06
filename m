Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D43EB28D6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951476B0098; Fri,  6 Feb 2026 02:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929A96B009E; Fri,  6 Feb 2026 02:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F5B6B00A0; Fri,  6 Feb 2026 02:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74B016B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:22:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2BB75B07E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:36 +0000 (UTC)
X-FDA: 84413189112.10.10357C1
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9319C0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZthEn73D;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XrFsXOEXMwmpE+X7noVwyIey4LQ89wmI4Q6a+MI4j84=;
	b=RApxtxnHhevMO/nPhmTBmlG+tMtYWLEmv74rTRgpvrZJAFXAfAx6Tsa/yLQCgJxP2HqpMy
	xNxKeU3xOpcY6ilTpZnohNR5qg3rPEz1sZG698V61HN3wom8lZjNuCnejsSpsp+jeZKrpg
	+Ti0Da++UlB7AV2zztCaGibaEAOuwcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362555; a=rsa-sha256;
	cv=none;
	b=Xny6owJH1RYs28ViNnKPtWKQBQPBgV2NR1s5fzEELV5nSY6+DwG156jnfo0hlPCoegavpZ
	nBIVnpNDzvmwXUP2Ipzbl+c6w+VS2qC6t6ZQhlfCoqlZzUsXLNy4b1ph6T/viFES1tHYWX
	Chyc+EoJZzDbmFdf5P4SssFOVRCJT2Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZthEn73D;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770362552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XrFsXOEXMwmpE+X7noVwyIey4LQ89wmI4Q6a+MI4j84=;
	b=ZthEn73DhQMpdw0mejJoSncG/7xCwqooUAFD5+w2kfvO+ILzsyQhn4EWIpHRg550dU2drV
	HMdw15SxF0yj/wsHKFu+8sovUsh3uMIk3MVfJeydVqkX5C+ibmTZlN/mCxD9U8BmDw9Dmu
	c5ReqVc4wiHyTXNbPw8eQoNDoezjqXo=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri,  6 Feb 2026 15:22:14 +0800
Message-ID: <20260206072220.144008-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E9319C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ytn98z7tkixzxqkoi8x91ukkf3s56jhq
X-HE-Tag: 1770362554-286744
X-HE-Meta: U2FsdGVkX18nTAnBfRe40WoeMIlfACA7YQZq+eWnBVwGtbwR/CoXX3TMOl6Nmp3MB7kI+gLPEGLxgBpKYmlszHDm7VGqGTFmcbvsbDjIEn2YTNA5f4PIvpxKSx/zrsP7SK7Jyj7e7AlR+aNHJSQ88INndxhMHTSYq8MWBbSbtdu6DTWNw8z6FlPrLAji0J6bBOJCW9kGfGl4v22w5Gl/4iz7bYcBQTxxSINRft+6hjaDTgoikLB5DqcGjLtz9iEZ7/KV5n3SuraRHT6R8ttKTmA4iOeHG8wHpL+RRFQl18m23lhjplwYcGVk6dkIKQceIzJ4tF4FqwDPnCQ3TC7jX7FC8NZeAsq7xn0yZ1ZCIJpe6jFtQn7kdBxRjrzRJLJmd75xBssDnSfqb5k7curjdgWSqnwbzg5MPvJbLrFbPLcaXgD4kj23pDZ04Xfa41jbzJZh0Gs7kcI42otf1063aGXvWfFL9H+W7VgGJ0kT1dKfxNch30SiHEXjQR+yA929LXoKXDalDeMKY+TZT94fK5JeVcI/mqD3C/1nqWRzKjANaxR41Y1fsIdCVTGKEzqOZNH6YkAxvkvaylXwumpIjqtcJhUhUFsKR9sYdFKg8j9yC/K7+2MaaKcai77VxZrYWoRgRhP8lafVvN+kbgEpmZmbKYeT8yq6gABV6BLSif6kkXO2meQ0SgXzuiSaizeNVgxj4ZF5yicjSZt9D9VfTfxUzV0AedTEomCIjccP5C7zpSoEEED1Ss7oFzWz10BD9d3o4LA9jQb10N4JalSeeKmNK2jLhUSDP1vItNy4r4ugbTmcLcDKgUjQSUVe3sebNAX3gA+A3ABOM42uSspH8RPhAYLqCALt2d1PAFp/lAXBt/dm5qCLFeIacgEFQSi0bIhpHJtPNjBrqPzioZvGbuI5zI8OFFdS6lGvSmv8RUlkkmFshfnbr18zsaXeRT8xvRMqOWRA6hY+0KhZKgo
 ugzU2rql
 p7RC4eWUdbZX4Sfi+AEt7ByiRvTj+I2BnpuhH44vRjuKIOW42Wz6StwTXcesBMaRydSbvBurKTrDXIESyWZbM/Xqh+I6X/0sf1wgHObYBN8nlh/ZV3k/Ju5vH3QLD/AcvSoqOCgQgPFkE4ALXXVpbjipTpKb/6JVFbjr21oVTtpmWuaIjEeCo8JKNuPumfDmsaEXROb6o05rZw0Maqv7/m2gek7+j0eiJMHwQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In containerized environments, knowing which cgroup is contributing
incompressible pages to zswap is essential for effective resource
management. This series adds a new per-memcg stat 'zswap_incomp' to
track incompressible pages, along with a selftest.

Patch 1: Add the per-memcg zswap_incomp stat and documentation
Patch 2: Add selftest for the new stat

Changes v1 -> v2:
https://lore.kernel.org/linux-mm/20260205053013.25134-1-jiayuan.chen@linux.dev/

- Rename zswpraw/MEMCG_ZSWAP_RAW to zswap_incomp/MEMCG_ZSWAP_INCOMP
  (Shakeel Butt, Yosry Ahmed)
- Drop zswap_is_incomp() helper, keep opencode (size == PAGE_SIZE) with
  comments explaining the incompressibility check (Yosry Ahmed)
- Add documentation in cgroup-v2.rst (Nhat Pham, SeongJae Park)
- Add selftest as a separate patch (Nhat Pham)
- Add reference link to Chris Li's discussion on the need for per-memcg
  incompressible page tracking (Nhat Pham)

Jiayuan Chen (2):
  mm: zswap: add per-memcg stat for incompressible pages
  selftests/cgroup: add test for zswap incompressible pages

 Documentation/admin-guide/cgroup-v2.rst     |  5 ++
 include/linux/memcontrol.h                  |  1 +
 mm/memcontrol.c                             |  8 ++
 tools/testing/selftests/cgroup/test_zswap.c | 96 +++++++++++++++++++++
 4 files changed, 110 insertions(+)

-- 
2.43.0


