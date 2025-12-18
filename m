Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BF9D68BE2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B2A6B0088; Thu, 18 Dec 2025 01:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08DE6B0089; Thu, 18 Dec 2025 01:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C148D6B008A; Thu, 18 Dec 2025 01:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B08166B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:39:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55CB41371FA
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:39:26 +0000 (UTC)
X-FDA: 84231640332.26.2380A9C
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1FFEDA000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:39:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=DtwNyro9;
	spf=pass (imf25.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766039964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RURcNCeCYd6BsieRLTf6v+zeOuKA6NvzwDD7Kc6byDw=;
	b=cXzJo9CoC4ct3tJ4Oxruwk4iI+iQM6DRNY+5z2fmJqyoPTzXzMcQjfVwR6zm3ffYfPIEBI
	0te2jSgZBIDX2zdKHK3O/w76AQiVpB1MXwcJHO9/tUXcMyzeLojMV7NcrPit5YkTIGsQIf
	hJGtUAJPA/wY1+2XlH7DQOLthQtqJTA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=DtwNyro9;
	spf=pass (imf25.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766039964; a=rsa-sha256;
	cv=none;
	b=zwpDomsq6kvn1U+/BSX+E2H/IxiigZ31EqMqefMNn6bv8jX4OswBX8USUKkwNWS1DXPFrK
	86jNnN3DOmmyuovRuDbR6VwCa+qmpAjXFx7s0T1fT55ekIWdQad1wE93AogTNhjJ0HO4Hl
	aPkil3O2ZCk3WS707Ofu5MQ8xXgRQwo=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=RURcNCeCYd6BsieRLTf6v+zeOuKA6NvzwDD7Kc6byDw=;
	b=DtwNyro9PTaw4nhSkXQejzfAqp+HqjhtOrAViG4+R1UC0mO7kCHVdmzlGFgfRsv1YizLXWDhJ
	RXX1Ovsk3xLzSF4lELvWYjXXp6+ME2dT6jKWhIGmFW6H1DUN6pV5WGcU/yNNPvk+Cz3xlBn8Umi
	U4O2riFcdS4gUjUk1ewXwCE=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dX1Db2T2YzYlQ6R;
	Thu, 18 Dec 2025 14:37:19 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 14:39:18 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 14:39:18 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH v2 0/2] kfence: allow change objects number
Date: Thu, 18 Dec 2025 14:39:14 +0800
Message-ID: <20251218063916.1433615-1-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Server: rspam02
X-Stat-Signature: s1mgggqem1ywtaprgdndhdcfx5j8k4wj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FFEDA000F
X-HE-Tag: 1766039963-341276
X-HE-Meta: U2FsdGVkX18NJK1S8KgGf7Uy7MN0j4SSxypnx1Iv2AdaY3a3q6CaAsX5q7ruxjxYfTfURga4oPpSdUwuConFJmPVXZMH1ys2yNHyIeQCgqJ90ZxkPaaaLLol9irr5sL8vhZitqBEcOTFdtZjxAioliggcfl83/G+XIACYTZbDNpHPvlS5eLwd4kGL9ogvd/31q6cX0NHOvDMaWDJ7kPTIWPIGu2erEMbb+0Zd7oOy+ULon0rnT2v609Da0J6Ma+BOBwkkGkNOY7H09wyvmkc9NH9QDQ1dmXEOQCdcMIXFi7ldCEw3rZuunhh/3A0iIY7cxDjAtqX7E4gRGlaKCDJl9NGBckziKJNFusqwUXkQN2ZhHEdBCdqgq0vIlMtVqj6SG9DgepYygFymccwf9Xt29Rl9bZFk1VdCryuZNc7fNGGxjFUEW5jsGI6wbcXfs16Bst3i+k+96Q0nDFPTiPMbYjI2D6FJYzJpkhz/UOeBnwiBPuvsL9ej798Xy1eM4LAeIP19nE5Lsk+pYLImLxmPgeTzVA1QFcdRoj4tWT/XWoSZ3Id65qbf8GQPPMD/y4osrYPHyPcCq8uRY88o7ilCQ44jvtYdm7SNTDGf+hzzswT9Pgr7fDrRsyKF6iPYloH7HoymRi1dwzN5eO/xvFuM2zPh6DUOqB5wZXT5/ylRNQqBNeGHBe7mtoqDOhPUUfH1ZRmijCx2yZcYOFRsUSnqi9CU1aGwjLjRilwuZy3uhq1iutt1AUOrX/zDx6hRTN+Ic46N+nP/behsET92ESAPAI+s7wEt033ScssWb7OACfwnGXkJEYF9DI34Or/wpvEudnR4e5qQDe2NHu49r9/mjSEeeIi1VAsqFP15AyY9QE1G84tQk/p1GfzmH0V8lAPuMX8a8Wo1snA801KOTosPly0C2vrpf+0vItSfR/56lHTCMosjwAc06GxLM7sjVX9tngifC24fZPMPP7Qa8m
 5FZH4KP2
 HXe8PhSQvfz9hRhQGahPacmRME2tzIt0QcJlZeBlEHDFsKVmZ3jnhc77bCON5FXvxHPlyB3K89eYrHhHbZXabYyXnLnhPwT6QwZdpq1cT9I6K4JiHU1loVBmhT5VtIwRXwIkZemQdlCQSv/ed9MgrcTlGxi++ryIGhIAazr3bdWcoRDZntUgmOU5ScI5sPRVUoDMbX/8zCz9BVL+A+Aa2F4ai5ytAc5PWdVZsTFmhxxUsia9T6Nv54WgxX5HJwiCtfgRswzdm9YFJRjLy6CKb7Ex15ZW9UYpSxA1n8+BUtTKalpD99+3h7bAFFrH1Dy3DbNAg979+kIUJ1SHqTVDGRukgftkuvisphokzBcDTwlYRtPp/XFafLAk600XEVTkjWE+gQXi2ZWiIGYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

patch01 use common KFENCE_POOL_SIZE for LoongArch
patch02 allow change objects number

v1: https://lore.kernel.org/lkml/20251218015849.1414609-1-yuanlinyu@honor.com/
v2: remove patch02 in v1

yuan linyu (2):
  LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
  kfence: allow change number of object by early parameter

 arch/loongarch/include/asm/pgtable.h |   3 +-
 include/linux/kfence.h               |   5 +-
 mm/kfence/core.c                     | 122 +++++++++++++++++++--------
 mm/kfence/kfence.h                   |   4 +-
 mm/kfence/kfence_test.c              |   2 +-
 5 files changed, 98 insertions(+), 38 deletions(-)

-- 
2.25.1


