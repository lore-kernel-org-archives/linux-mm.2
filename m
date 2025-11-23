Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011DECFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACBA6B002D; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D806B002E; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A0D6B002F; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 384A76B002D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D764785E66
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
X-FDA: 84142745652.05.74D1884
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 60A9840006
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDw1OiBu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E1Xzd+apb3fo+KlTUo8LRMhSfeix9c8+eGaGO46d4L8=;
	b=Oyzn/IQOF0AAKzD+Ts04DnZCKX59sOV97aKmBILSBPeWlcfCxwHIAo+kMb4JD1CfS+4E1o
	rvcIPGFFDNpKUr+HB4zh9qA1bmeOjPS+z46wo/tjJvRJataKoFCVLhf/FtNNHivs0IENv9
	eJY9cH9rKfwN1TR1T6jPlvKHWo6ZkK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923425; a=rsa-sha256;
	cv=none;
	b=wYc5DaV2LAq3saL5qaZ4X098KXRxfnlvAvJYEhQn/0UJe9uJNC787E7alCSIFnvSUP+xMK
	GWBHVGd8Ukbij17ukC9hrSo3EAJldeQ7eiE6OrYKentm/tedE0YLM4KecUVj8O3QYxkceW
	N0v9MvjGNxPQTwZ+5kZmlqkVrxAWGaQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDw1OiBu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEAAC600C3;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3232C113D0;
	Sun, 23 Nov 2025 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923424;
	bh=/pmP4EMktKLgoBMD3SKTislBGBhK+hMUMXr37vr1LCI=;
	h=From:To:Cc:Subject:Date:From;
	b=oDw1OiBulVb+4PyhHj5wlxnpIfFM+xbGBo4ATR75+jNlSxbNZhRjH0NHtSbhjmqbc
	 TzaU5F/Qzn30oaaDFAj5gdv0o1NwIAsVtuu0JsBtJNed0B0ldqG8wkOn+dpV8h1d0g
	 IHfAr8Mi7popi/bTlxl1DkMVK2OdOkrqHuadzz+1UHHMMq1ZZ2K773qLVs+E/ytrZ4
	 2NnIvc2R0mseiG7Udoky0YvPzkPNcN0rni+vXUZFkke2RWxzxHmIwN4pY9lJlQj+c4
	 avlYSdc2Dd/x0eDNBe6oLJ5Z3lrr5egqR2SoZPFeeoXipABFxSaRDBMkoPnYEf26Ky
	 N6DtTG4QYgDpQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH 00/12] mm/damos/stat: introduce nr_snapshots, max_nr_snapshots and tracepoint
Date: Sun, 23 Nov 2025 10:43:14 -0800
Message-ID: <20251123184329.85287-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 60A9840006
X-Stat-Signature: 5wha6x16eciuw8eojechz76pocnj8zyr
X-HE-Tag: 1763923425-296878
X-HE-Meta: U2FsdGVkX18EHZVEIegxrfGpmNw9FWbAmxKLtKE8bmvPxP96FUsPMNYaxPxMsOTliq8HLggkKAl4rVERtrQOHGTOJH+bhGqXkrjzUZfjxLg3nI+HwXfsB2QAsaTlDTQDW27YuRy7VCO1mJdjTrgajERxJU8P09qflS3aQeu7Fjh/uB26MUsK02rbeUVdO+2kKsQrVvpe2PiJr2QotSbi6oyQ6El0/tFnV0lDZfldWc/0QQzTaNwVJ0F+kkYUokhwFpB6P++4A10CLM2AvSb/vAr0XsRGpPW2vngSeBBvgY5FwHcbecBavccB9y5UXrvU3f8VC1maiFnXTKC6QnkebZWbdKlpnYj1U+V5FVYp7sXg1oeZU9o3w3fTyHz13fkzkcgqNnMlyo0IDwKlQoF4iGNCjw7i1HNvCGQ+RAXYID2V1tuljzl8hB95cAD4gk/kOxxsugUMdbIWgSL6dve27XFLeZyo054TxzoNnce6fE4/VVqnna8tSBmaX/nGfldMj8r93EvcT4S/4tDHKOMiSAyUXL4W4+5ewkGWLa0VsyK9scaF38Oc1pnP2x2CWGlOAho7Hpgf0JBEUKxubju8eoAKbcqJ0U6OnAgSnI6yyvJ0EKdGLHmtZetuev90Hdzcw3PMHsmiCVYsHac1RLt8FFFIKqTZ9xVOOI+zw1nDzWKSapL4eZAUe+zeZQEG+W/m9u3uSDfbDMq48cPiy47cA4uT0f+N9VE2DVq3K1bvafFlAisr74mjoONIHe2pDXo3PF1bghbM3JMiHlP20pKCYvOb4p1u1nwsuevFPXqFucHp8UaoiggD0fxxc0faBeUHGjWrnrqIwirxbve6wl+K5HKrX9edRWxrX4tX2/rCiej65UQAKJp/xYTygVqv1uZP1G7TgWUUO+rQfyPUa9vycvwXf5oW+8jQifwKw/FvEPyKvijBykbW7+7K3w5IJ0qmbyRFT8m5jS9eIduLhbK
 UR6YqDNt
 TvlmmOsnG0RGSugT4Zp0RwserQTvwrVCzEOGd7JbYRQ9V1baHTZY1IA+oBT4dyiQ5LKCoir63x5xTcgkCDMaP7CK9K9d5648sfaLJy7oiOUy1vrkd4mGHRKZBJFDAXmWGNpbJ+ST4+GBngWIsreSKUt3e177ba1pwbbOFcVq6P4tf3oK7xh4rviWckSY5oVHX+4W5y0P7fJRW/BtTr8MN74WBdOegZfn4B4+8X2lX9JKr4RshJzVJVw3vomdEE5UHoNdR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce three changes for improving DAMOS stat's provided information,
deterministic control, and reading usability.

DAMOS provides stats that are important for understanding its behavior.
It lacks information about how many DAMON-generated monitoring output
snapshots it has worked on.  Add a new stat, nr_snapshots, to show the
information.

Users can control DAMOS schemes in multiple ways.  Using the online
parameters commit feature, they can install and uninstall DAMOS schemes
whenever they want while keeping DAMON runs.  DAMOS quotas and
watermarks can be used for manually or automatically turning on/off or
adjusting the aggressiveness of the scheme.  DAMOS filters can be used
for applying the scheme to specific memory entities based on their types
and locations.  Some users want their DAMOS scheme to be applied to only
specific number of DAMON snapshots, for more deterministic control.  One
example use case is tracepoint based snapshot reading.  Add a new knob,
max_nr_snapshots, to support this.  If the nr_snapshots parameter
becomes same to or greater than the value of this parameter, the scheme
is deactivated.

Users can read DAMOS stats via DAMON's sysfs interface.  For deep level
investigations on environments having advanced tools like perf and
bpftrace, exposing the stats via a tracepoint can be useful.  Implement
a new tracepoint, namely damon:damos_stat_after_apply_interval.

First five patches (patches 1-5) of this series implement the new stat,
nr_snapshots, on the core layer (patch 1), expose on DAMON sysfs user
interface (patch 2), and update documents (patches 3-5).

Following six patches (patches 6-11) are for the new stat based DAMOS
deactivation (max_nr_snapshots).  The first one (patch 6) of this group
updates a kernel-doc comment before making further changes.  Then an
implementation of it on the core layer (patch 7), an introduction of a
new DAMON sysfs interface file for users of the feature (patch 8), and
three updates of the documents (patches 9-11) follow.

The final one (patch 12) introduces the new tracepoint that exposes the
DAMOS stat values for each scheme apply interval.

SeongJae Park (12):
  mm/damon/core: introduce nr_snapshots damos stat
  mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
  Docs/mm/damon/design: update for nr_snapshots damos stat
  Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat
  Docs/ABI/damon: update for nr_snapshots damos stat
  mm/damon: update damos kerneldoc for stat field
  mm/damon/core: implement max_nr_snapshots
  mm/damon/sysfs-schemes: implement max_nr_snapshots file
  Docs/mm/damon/design: update for max_nr_snapshots
  Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
  Docs/ABI/damon: update for max_nr_snapshots
  mm/damon/core: add trace point for damos stat per apply interval

 .../ABI/testing/sysfs-kernel-mm-damon         | 13 ++++++
 Documentation/admin-guide/mm/damon/usage.rst  | 11 ++---
 Documentation/mm/damon/design.rst             |  7 +++
 include/linux/damon.h                         | 12 ++++--
 include/trace/events/damon.h                  | 41 ++++++++++++++++++
 mm/damon/core.c                               | 37 ++++++++++++++--
 mm/damon/sysfs-schemes.c                      | 43 +++++++++++++++++++
 7 files changed, 153 insertions(+), 11 deletions(-)


base-commit: 522f1a9fc5f1f0a11af39ba5bedae446322ca0a2
-- 
2.47.3

