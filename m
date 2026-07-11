Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8F5C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57026B0088; Sat, 11 Jul 2026 05:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F566B008A; Sat, 11 Jul 2026 05:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BC46B008C; Sat, 11 Jul 2026 05:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF98B6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:12:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1A50C40D2
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:17 +0000 (UTC)
X-FDA: 84975929514.20.829CAE7
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC1C61C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:12:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gwX1St9y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783761136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V0U6wuv8Iso5WD0+W0vrvXxkpcyPWjDPaBsrbVb3xvE=;
	b=hL7nLHhccW+7RCJrxU/btygG957GGmDgMXjG4nDkqC44Oa5sbZ2x8Sy+tscQQbA19JH0yP
	2h4SjdjyThA6qF6nXN0KxUlcXR0hjksyUNrm79OfyVNn+YkIAhcq/hF9kqMCZQeGL7aF1Q
	wk4v8FeZRfDurC81jFvMyfA2hgVLBPA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gwX1St9y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783761136;
	b=X4HJOYsn9xgjbWYC/vfmb31JcC1w8iTVTKq+vW46Bn3+EZHxClxLLO5oVWayurF8J9fQ8f
	moM5C5x8CrDMqjw/yj5tXVI1QVpynoEkIQXbbv8TrCJtrlzgiM2rRMf45y/bYPpI/N07zG
	qyq1SW+DvCIZkgvd9TgbvhnNq/0JzIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783761129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V0U6wuv8Iso5WD0+W0vrvXxkpcyPWjDPaBsrbVb3xvE=;
	b=gwX1St9yWookbKnJlLCfLdPMVyJcTPtp3PL/LemJy8e8plxTihXSlOHVQ4hpbGJKZNwNhA
	90GBmQcxmCfOkixN6YPRgwdIfiRWOdXfIqw5qjPPk1r6MBKih3LJk2SKZV9gMxnh2NGKoA
	s+MM0hUy2/hW2BhTobpo+Yi1eN6sAzw=
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 0/2] mm: fix node reclaim swappiness handling
Date: Sat, 11 Jul 2026 17:11:55 +0800
Message-ID: <20260711091157.306070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BC1C61C0004
X-Stat-Signature: humjmg6qo6a3ihqec3hunhngezc85yf8
X-Rspam-User: 
X-HE-Tag: 1783761134-419722
X-HE-Meta: U2FsdGVkX18IeGH8zsYyGRJBDSythzjQ3tZucsUMrdOtsxdl6HI1OGYjVNrC/VFPbBDrooDkdVESc2lMUVdmsvn8vtZ5w9IePpNfzxzZ/+Kj75U9u8OGX5Bo2cMNimbZYG+lsNZzmxDZsP2be/aXrgzD1VTu6RE5haAM/evLaFcOl9DtqZatDkW3Sm5axIKbTphHvzz0rK1lZg5d2+gcPQ9px+zBDNwRCUS3llOF9XNm/PxwQudmDuZkSK1YQRZ+2ojLEtIOHANbwGzSvlIVGpoO9aCxjLFNfXmr3A2IxujO6NZYAVHwlShcZ7hhBu6d2y79cU+qovXPF4SZLyqTylK7Mbcx6LhAvLpAevTuqPDl0UQF251oo0w/v8E7zWXHHFDnuyfN0+8lbHkUPQx+Ppq3uujiSIGffDiXfikCcKDTQrVOZX6HrIaUrbx2pQLYEwzXt1LkEbXeWJW6EARPfwWsa9v5wA+/BnayHtfMp2xjoWiTKkONZ44qfVBxRQUkpEbS4p7S7+cVf5ve64qKfZqgk0mQelrbDd145P3p+vpynQD1lV2YAggxaCtIUn7no0bCpVDnj9mKQELW8WJAXWYdffBAX7dXKyIEMGbx42Z89Kr/llXf2AKTHRNP2fPGX26q/Hv5NmKoSl91jPJuP5/JojrzVb6mhVw/mAfrajMjB+4Ya6lHsIqC63o9koFvi+G0sZ8qRQqdkPWQWhmR+ggajQQQ5pmQMx2I4462mtYN+pKX43ll1B2kREdQO1mCyK3SPJzorwULTucfYPWNRQ+tNejrcK9Hoq4E+/O5+YRTe+KIR48zfopCE2x87U2uh4/14OPVZ6NpdThIGJkC3IdEjIXpA4zWC4YM2E/DUyBEMPvVKMQAgOpALYZXcmU/ndRKhI1rsE7KcAkgMCwK5RruUiDZpBjEw/JJHFWI1qnjhPMgVQVvLmTZF+OyGQNhkxEC16HoFmG4R+UNLUH
 dep2g//y
 VC3x3RACsEG5gT48yXznQ2zpURwo2EFLGxKIVOMg1OGmZTNEEBXtu7JdzT4RC+cMn/95Jh1sVnJIfV71qW1QkkUN2nMn2HiVeeOvE9xwcSxM10bgFDVUgVoxmDnm+uw0TFhdjK+YhWQEGINEOhAZKDrRmd6uEEed/eMYTzYtErgf4NYfBgV3tVKnToVc1hOvt0Wf5u9WemntMTH0BI5hSau0p9OD7bfH6w6p0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The per-node proactive reclaim interface
(/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
but it was silently ignored when CONFIG_MEMCG is disabled. The root cause
is that sc_swappiness() had separate implementations for CONFIG_MEMCG and
!CONFIG_MEMCG, and the latter never checked proactive_swappiness.

Patch 1 moves mem_cgroup_swappiness() from swap.h to memcontrol.h and
makes it handle both CONFIG_MEMCG and !CONFIG_MEMCG cases in a single
inline function. This is a prerequisite for unifying sc_swappiness().

Patch 2 consolidates sc_swappiness() into a single definition that
works regardless of CONFIG_MEMCG, fixing the node reclaim swappiness
bug.

Ridong Chen (2):
  memcg: move mem_cgroup_swappiness to memcontrol.h
  mm: vmscan: fix node reclaim ignoring swappiness parameter

 include/linux/memcontrol.h | 25 +++++++++++++++++++++++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  3 +--
 mm/vmscan.c                | 17 +++++++----------
 4 files changed, 31 insertions(+), 33 deletions(-)

-- 
2.43.0


