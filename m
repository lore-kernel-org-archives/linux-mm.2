Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79AF2CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354996B0088; Wed, 17 Jun 2026 20:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE406B008A; Wed, 17 Jun 2026 20:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEAF6B008C; Wed, 17 Jun 2026 20:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBD026B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:57:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 524131205A9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:05 +0000 (UTC)
X-FDA: 84891219210.06.98A58A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B15F2C0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDuBTmeU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781744223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gdcUowoWlmdk2SHRCzl3vHrMDgH3mpiEDGCJ+4GEJJ8=;
	b=8CGmbLCQ3yRegm3Y9vxNpSDQI4IIJh8tkbedGdAIWjH+PonUbaaIbRHnDkLBqC58IWhwic
	sU4jA5Mari2RXC5wRlxf8B0nlElMUft3RT0baIhf+GToDE954DKv3UTmpuwDdZd2TPfjVD
	mKGXxyWR4fWyq8FVfWj8tD0b7jGy+/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDuBTmeU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781744223;
	b=3weEPcTMHq91dlFm6TIokUilzMPSm0bx24Yw3O38+gqh0gLG5HMZfnBsi8YtoYG9VpbL4u
	s2tT31XYPOONCITPSOk2539PkgzNoSqRR8pozJSL1tcurEZJIxC4Uk6sjjZaj0OhEAuGXX
	Dl9ckDoK9yz74qmzW+X/7ZPeT1sqtxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3290E60052;
	Thu, 18 Jun 2026 00:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231B1F000E9;
	Thu, 18 Jun 2026 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781744222;
	bh=gdcUowoWlmdk2SHRCzl3vHrMDgH3mpiEDGCJ+4GEJJ8=;
	h=From:To:Cc:Subject:Date;
	b=TDuBTmeUIlIJG5vi4cjyDGzbdJDtI4RwIHhz7IyJCXAiOX8xCo7ciRqhrXJoeY2zj
	 NV+fm2VPvCBHT3rFeMnx7FGnUUfaAIyn4oXISjt2gwv0PMY2SPfFIEtF8ohO4QTyD1
	 HLoP5BBwtDa1LiDT+fiqKM0mdqIS48m/Aj68hEJrnTmFY6LOZU3Zt+Y/+Z/wNGHpTN
	 Uj3qbt4fxjlEiJxAU0YRWdjEMS+X8GRtu5pzIM70IgHlOo29g4b8ZpOHSNmachOjhP
	 4+rBfPAgMTNkayej2tgDgy4Ih0nHPS3JGOt1hhbSnxDbHqyJzos5eal963sR26gC/p
	 oGuszUMYKPTuQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/sysfs-schemes: fix wrong directories put orders in error paths
Date: Wed, 17 Jun 2026 17:56:46 -0700
Message-ID: <20260618005650.83868-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B15F2C0005
X-Rspam-User: 
X-Stat-Signature: 3i8efqi8buaf8ofm9ufrst8c3buyc9t3
X-Rspamd-Server: rspam09
X-HE-Tag: 1781744223-871260
X-HE-Meta: U2FsdGVkX19MSBQYfDUX00XOYmdJM+DeKAsRlmcOmBvBTGu4d0GoiGZJmnBvkPXf8G0BV39WInt4vC9HkgnLYEZSMwLvCiGWnqKAlkWK7yYhZlqtz+2nu3Ncaf5CEG/dLRbWtnHtnAON72e31CtIcJM7U+0WSMCtE4y31e1A1kp+KifIVVSBoMn0vyI8HKHbBOQoWC4cQvAknVloP+PDhil7bd5JfLn4gtjjq10CJrrneHPbQmmcmMJV3IJdFV7iE4KeyWIXwus1/kHk1c/XbdJKBT7nZ7izjgupljaAXtS9aytxSHiEFCv7qLr9YaGt9SiRhCgyOLSZTpzkmmtDGNyXXo3nGm+Ip9G95rSxro/6iecpdOdVCq6mKGYYPO5Ji1uEA3oio1LCLJPAxOpnqUQRdIuBDgM6/tjCf5aVsXMfoV8LKd6uiwCsTY52htzt5z5D+lkDqMpsmz3OItxVKcOh+fdSp4SpuUGlUm64YBb9nFJTQVocXgFinqEL/KfR6as+Oc7mxkJlf8MnogJsl4vTXSLTSGLsNSbULz1tgZzE6En+00NTRvJO86w3PlQH6Q792A81a7XyktzZ0Ud/C62QThPcuafhoO/lNuqXiDgscdi/Y3x1qvmTQfjspeJm211MJB2nlylANyFncc74Z6KLmfnSWKs2qqh8TjVLiU9gNKnvPLYoTcLx7rhecw7iaKX01kOEWzA4pCo/HBTFVuHGpSHOF/v7jb55wpaieJXAeq+0kiMqa6wc3bc0LfJUAFu+WmWD2JrMD1D2EzuWH/rhmk/1o0MNJb9rNrw/6a/6qv05ePmohWiqoFTkQc7ZZMfFCm1i02Yt1IqblflrRdgY1cw7RyHB6SvDnS3MqyWg6BC7lzLR0hya6x9QdcPWKX1PnaxUCP1jJV1fxpF0v0Z/fd+pcg6YfwqPaXzTgSOZPPqel+0Dc6POiyOYUkpTV26nyhV7V5osXIJLPtP
 YSpU44kf
 wXw8wSsKa5k77+gUpD5ho1PEan0P8MR4DMlPPUeEMlX0nnmsuIBhMXhr9bPvAIqXBa0Sjy547Vtr6w9lj+Qgx/jeOcPPHZZYVlA83Jo5ajY9o5RuBbzdXXpSaNJCzU5liD8zgIgSiBSLdCAmzX/mGx+/3w572pcso0tJmZvunl8Y1WCLX16ShDO97O54XWvAb1sA856On5Kz84c18DKsfGwzsaOzjoEOYGyTuQ5C0e/RgcH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Error paths of damon_sysfs_access_pattern_add_dirs() and
damon_sysfs_scheme_add_dirs() functions put references to directories in
wrong orders.  As a result, uninitialized memory dereference and/or
memory leak can happen.  Fix those.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260617135551.86013-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260617053308.83200-1-sj@kernel.org
- Add damon_sysfs_access_pattern_add_dirs() fix.

SeongJae Park (2):
  mm/damon/sysfs-schemes: fix dir put orders in
    access_pattern_add_dirs()
  mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error

 mm/damon/sysfs-schemes.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)


base-commit: d20942f0d52b1cfa54931e00eeaaa2350ee46169
-- 
2.47.3

