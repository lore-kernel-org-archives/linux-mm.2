Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4D9EF48D8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA136B0005; Fri, 13 Feb 2026 02:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D336B0089; Fri, 13 Feb 2026 02:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468E16B008A; Fri, 13 Feb 2026 02:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 339E36B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:18:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF04BC17E5
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:18:49 +0000 (UTC)
X-FDA: 84438581178.22.9E5B1AF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C01FF180005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:18:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ofPx+WCp;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wrYq2pAJJuqrmBI86q10Z6dZRJSTibQvGpw+Z8u3inA=;
	b=iKu8wa9H11U/nDo7NuPCc6VggteCA+H0lAnf5OPZrzk5VK0dtpmXYYmqTxoG5tRZh/ynDh
	Z/4PN40l3+MtzcUqVdSpHc2BuKEuklS/ImiwBYOQwG+3pF3ZaRsBne1Fjfco265Ln69xfK
	ripktMDciYlkSm+xq1ivZHbhY8vfnTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967128; a=rsa-sha256;
	cv=none;
	b=fT8M9b/MpH+3insSrRyDu8PraX5H+Y0yJsgMUGeUbf84YCFvuMnoqb0CfP6kWgtPWd+wAW
	ufuMYOybuu8rxlZI+0lZ9vJipgxEqzu0Fon6FLQo0r2XrJta9hVAHdsrT/sMEeQ8xi5G+p
	Ifp1OeXt8+j1VD3KkKA6TWMh6TT7CBE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ofPx+WCp;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wrYq2pAJJuqrmBI86q10Z6dZRJSTibQvGpw+Z8u3inA=;
	b=ofPx+WCpUD8w8iUlCR3WoE5H+/NFqYmwHjeEhP/opwMxn+UHtNg5RK8MyxzEojkK5uUO+E
	aPX71PF+yk9CRysc4uGf+RVU3yUiOuMpzYiv90NB9CJ8dpbr6dV/HhnDmvfxGtYEOAD6v8
	Msq0w6OwAqDpSg2Yb3psPeErNC4hGcc=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
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
Subject: [PATCH mm-new v3 0/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri, 13 Feb 2026 15:18:21 +0800
Message-ID: <20260213071827.5688-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C01FF180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nt4mox5t34o6u8bkwuq9pfgg6sbc4mmi
X-HE-Tag: 1770967127-720757
X-HE-Meta: U2FsdGVkX1/3YwN1ZiJRZ1EvRKq301f5Mi84YRlhgufVUBF9cqf0zSaGoA23KkBqtGR7oIF10EW2YxHcT1UsTIPtTut/qkFDgaolxMfFa9rT+R2rmDz1+8cmRJecarF0wZcwA1r6D9kTD72iLiAoMFFePuTzS9XgmRcplMsO27RkNknlSDUNDrhiRMfCtGWU5ola01wdz60uxIl8ix3YpK0r7S9koTD53ZkgHMFVdG9o1ybF2DztN7+abgoErCNK4F23Fp3zNMG6t6kFaRo/5OVy/OYk/cY0q3VGSD1yNNVqpNhR14jO9GGizwvptfm9F1cUb30KXectlvBhj1ieDk301kZfKVY2TouT0L+qbUBrxLvhk6KM2/Gu4mo9ryVrocJmb9sne3exKdpTWB8/qRYYmKdI0S/G1jbcYQgSWoGRk+fWrO150bfCZc35TrzyEy1D+CcJLp0A2CsBhe+FvntHmkTP6NhIN3qeeztvWIZRkzS4R48Vw+7O6WhpZq492TJojyC9vBMw39ll8HUTnsBy3xWJora/2wJTVyOYbmakiGvXau/U5LIfCEs6WGnfwN8xd4s4s+G4DkCjIy85YBKR+MuKJfFFrGNRh/sNw/E4cg5mkz+51eq1HAPRzHYb10oWBOTrWT58TOYKACcvL3cpLT+/ulgkehrsh2WWNqCjtIMusPWPQy/JAVvQ3IkfJFBxhlgKeOhpznwFN52ZmCdf3rXuF3jyh3wdxhvXyhiE+AC4/MGTBWIJy9jMefSyyt247DhN/6w6JnK5zNOy8RCD3YIuqb8b/GetioJ+IaH6/GAaEtUupRi9bORp9Va6n/IisaSxTWIQQecyzhQyr/tln5vJngXbuHt5q+qrNlmV45BTnbCJ1lzEoYSJrTLLwcPrx/2AMpdFV9CXvASBTKP8Kl0qny8dxXRMDYFD8YeBGaZ9R/2+vjR+qKb1k8QwWSIK5wMIAxEaAclfFFH
 VumDfdDe
 +uRnwMkEOGo5c8CKCc0k1lFltpTCR3gqIevYG8bzvRk1BhPM7qBhASkWMNfEbrakBxUG+jwKi8sKsp4NdC20zUFREZO0fuOSbbDfVKaqvvXqpveysUOYi0+Cvy3FMbO53kNj6t3vWtFaeB8Lyy1fO51I3kNWoUbSGkfJ9qtthHmwGcmglnq35kzQB5OhjRlV6OWG/+joG283ytlOMENReS6I4JA4OHjrHOwNu
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

Changes v2 -> v3:
https://lore.kernel.org/linux-mm/20260206072220.144008-1-jiayuan.chen@linux.dev/

- Remove inline comments for incompressibility check (Yosry Ahmed)
- Use PAGE_SIZE instead of hardcoded 4096 in selftest (SeongJae Park)
- Use pipe for parent-child synchronization instead of usleep
  (JP Kobryn, SeongJae Park)
- Use MADV_PAGEOUT instead of memory.reclaim to push pages into zswap,
  and use mmap instead of malloc accordingly (Nhat Pham)
- Collect Reviewed-by and Acked-by tags

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

 Documentation/admin-guide/cgroup-v2.rst     |   5 +
 include/linux/memcontrol.h                  |   1 +
 mm/memcontrol.c                             |   6 +
 tools/testing/selftests/cgroup/test_zswap.c | 136 ++++++++++++++++++++
 4 files changed, 148 insertions(+)

-- 
2.43.0


